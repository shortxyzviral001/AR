extends Node
## Autoload : audio 100% synthetise en code (aucun fichier son externe).
## Chaque effet est une courte forme d'onde generee en memoire
## (AudioStreamWAV construit a partir d'echantillons calcules), jouee via un
## petit pool de lecteurs pour permettre les sons qui se chevauchent.
## La musique d'ambiance est une boucle courte generee une fois, dont le
## pitch/tempo augmente legerement a chaque secteur pour donner une
## sensation de montee en intensite sans regenerer de nouveaux fichiers.
##
## Volumes : chaque bus (SFX, musique, cinematique) a un volume 0..1 lu depuis
## Settings et applique via volume_db. Un couche d'ambiance de gameplay
## (hum des moteurs + souffle spatial) se superpose a la musique.

const MIX_RATE: int = 22050

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _sfx_streams: Dictionary = {}
var _sfx_players: Array[AudioStreamPlayer] = []
var _next_sfx_player: int = 0
var _music_player: AudioStreamPlayer
var _music_loop: AudioStreamWAV
var _cine_music_player: AudioStreamPlayer
var _cine_loops: Dictionary = {}
var _ambient_player: AudioStreamPlayer
var _ambient_loop: AudioStreamWAV
var _external_streams: Dictionary = {}


func _ready() -> void:
	_rng.randomize()
	_build_sfx_library()
	_build_music_loop()
	_build_ambient_loop()
	_try_load_external_assets()

	for i in range(6):
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(player)
		_sfx_players.append(player)

	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)
	_music_player.stream = _music_loop

	_cine_music_player = AudioStreamPlayer.new()
	add_child(_cine_music_player)

	_ambient_player = AudioStreamPlayer.new()
	add_child(_ambient_player)
	_ambient_player.stream = _ambient_loop

	apply_volumes()


# ---------------------------------------------------------------------------
# API publique
# ---------------------------------------------------------------------------

func play_sfx(sound_name: String) -> void:
	if not Settings.sfx_enabled or not _sfx_streams.has(sound_name):
		return
	var player: AudioStreamPlayer = _sfx_players[_next_sfx_player]
	_next_sfx_player = (_next_sfx_player + 1) % _sfx_players.size()
	player.stream = _sfx_streams[sound_name]
	player.volume_db = linear_to_db(Settings.sfx_volume) - 4.0
	player.play()


func start_music() -> void:
	if not Settings.music_enabled:
		return
	if not _music_player.playing:
		_music_player.volume_db = linear_to_db(Settings.music_volume) - 10.0
		_music_player.play()
	start_ambient()


func stop_music() -> void:
	_music_player.stop()
	stop_ambient()


func set_music_zone(zone_index: int) -> void:
	_music_player.pitch_scale = clampf(1.0 + float(zone_index) * 0.035, 1.0, 1.35)


# ---------------------------------------------------------------------------
# Ambiance de gameplay : hum des moteurs + souffle spatial leger, en boucle
# ---------------------------------------------------------------------------

func start_ambient() -> void:
	if not Settings.music_enabled or _ambient_player.playing:
		return
	_ambient_player.volume_db = linear_to_db(Settings.music_volume) - 20.0
	_ambient_player.play()


func stop_ambient() -> void:
	_ambient_player.stop()


func apply_volumes() -> void:
	for p in _sfx_players:
		p.volume_db = linear_to_db(Settings.sfx_volume) - 4.0
	if _music_player != null:
		_music_player.volume_db = linear_to_db(Settings.music_volume) - 10.0
	if _cine_music_player != null:
		_cine_music_player.volume_db = linear_to_db(Settings.cine_volume) - 8.0
	if _ambient_player != null:
		_ambient_player.volume_db = linear_to_db(Settings.music_volume) - 20.0


# ---------------------------------------------------------------------------
# Musique de cinematique (boucles generees en memoire, jamais de fichiers)
# ---------------------------------------------------------------------------

func play_cine_music(mood: String) -> void:
	if not Settings.music_enabled:
		return
	if not _cine_loops.has(mood):
		_cine_loops[mood] = _build_cine_loop(mood)
	_cine_music_player.stream = _cine_loops[mood]
	_cine_music_player.volume_db = linear_to_db(Settings.cine_volume) - 8.0
	if not _cine_music_player.playing:
		_cine_music_player.play()
	_music_player.stop()
	stop_ambient()


func stop_cine_music() -> void:
	_cine_music_player.stop()


func refresh_music_state() -> void:
	apply_volumes()
	if Settings.music_enabled:
		if _cine_music_player.playing:
			start_cine_current()
		else:
			start_music()
	else:
		stop_music()
		stop_cine_music()


func start_cine_current() -> void:
	if _cine_music_player.stream != null and Settings.music_enabled and not _cine_music_player.playing:
		_cine_music_player.play()


func _build_cine_loop(mood: String) -> AudioStreamWAV:
	var parts: Array = []
	match mood:
		"ambient":
			# Am - F - C - G : pads doux + arpege clair (histoire)
			var chords: Array = [[110.0, 130.81, 164.81], [87.31, 104.66, 130.81], [65.41, 98.0, 130.81], [98.0, 123.47, 146.83]]
			var beat: float = 0.9
			for ci in range(chords.size()):
				var chord: Array = chords[ci]
				var pad: PackedFloat32Array = PackedFloat32Array()
				for f in chord:
					pad = _mix(pad, _gen_tone(f, f * 1.003, beat * 3.6, "sine", beat * 0.8, beat * 1.6, 0.09), 1.0)
				parts.append(pad)
			# arpege a la volee
			var arp: PackedFloat32Array = PackedFloat32Array()
			var arp_notes: Array = [329.63, 261.63, 329.63, 392.0, 329.63, 261.63, 220.0, 261.63]
			for i in range(arp_notes.size()):
				arp = _concat([arp, _gen_tone(arp_notes[i], arp_notes[i], beat * 0.45, "triangle", 0.02, 0.3, 0.05)])
			parts.append(arp)
		"tension":
			# Dronage sombre + pulsation dissonante (alerte boss)
			var drone: PackedFloat32Array = _gen_tone(58.27, 58.27, 6.4, "sine", 1.2, 2.4, 0.16)
			drone = _mix(drone, _gen_tone(87.99, 87.99, 6.4, "sine", 1.2, 2.4, 0.1), 1.0)
			parts.append(drone)
			var pulse: PackedFloat32Array = PackedFloat32Array()
			for i in range(8):
				var f: float = 123.47 if i % 2 == 0 else 116.54
				pulse = _concat([pulse, _gen_tone(f, f, 0.4, "triangle", 0.05, 0.3, 0.12)])
			parts.append(pulse)
		"victory":
			# Fanfare ascendante majeure (victoire boss)
			var fanfare: PackedFloat32Array = PackedFloat32Array()
			var notes: Array = [261.63, 329.63, 392.0, 523.25, 659.25, 783.99, 1046.5]
			for i in range(notes.size()):
				fanfare = _concat([fanfare, _gen_tone(notes[i], notes[i], 0.28, "triangle", 0.02, 0.2, 0.14)])
			parts.append(fanfare)
			var chord_end: PackedFloat32Array = PackedFloat32Array()
			for f in [261.63, 329.63, 392.0]:
				chord_end = _mix(chord_end, _gen_tone(f, f, 2.2, "sine", 0.3, 1.6, 0.08), 1.0)
			parts.append(chord_end)
		"warp":
			# Montee rapide + whoosh (transition de secteur)
			var rise: PackedFloat32Array = PackedFloat32Array()
			var r_notes: Array = [110.0, 123.47, 138.59, 164.81, 185.0, 220.0, 246.94, 277.18]
			for i in range(r_notes.size()):
				rise = _concat([rise, _gen_tone(r_notes[i], r_notes[i], 0.2, "triangle", 0.02, 0.15, 0.1)])
			parts.append(rise)
			var noise: PackedFloat32Array = _gen_tone(0.0, 0.0, 1.6, "noise", 0.1, 1.2, 0.14)
			parts.append(noise)
		_:
			parts.append(_gen_tone(220.0, 220.0, 2.0, "sine", 0.2, 1.2, 0.12))
	var loop: PackedFloat32Array = _concat(parts)
	var wav: AudioStreamWAV = _make_wav(loop)
	wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wav.loop_begin = 0
	wav.loop_end = loop.size()
	return wav


# ---------------------------------------------------------------------------
# Synthese : primitives bas niveau
# ---------------------------------------------------------------------------

func _gen_tone(freq_start: float, freq_end: float, duration: float, wave: String, attack: float, decay: float, volume: float) -> PackedFloat32Array:
	var n: int = max(int(duration * MIX_RATE), 1)
	var samples: PackedFloat32Array = PackedFloat32Array()
	samples.resize(n)
	var phase: float = 0.0
	for i in range(n):
		var frac: float = float(i) / float(n)
		var freq: float = lerpf(freq_start, freq_end, frac)
		phase += freq / float(MIX_RATE)
		var raw: float = 0.0
		if wave == "sine":
			raw = sin(phase * TAU)
		elif wave == "square":
			raw = 1.0 if fmod(phase, 1.0) < 0.5 else -1.0
		elif wave == "triangle":
			raw = 1.0 - 4.0 * absf(fmod(phase + 0.75, 1.0) - 0.5)
		elif wave == "noise":
			raw = _rng.randf_range(-1.0, 1.0)
		else:
			raw = sin(phase * TAU)

		var t_time: float = float(i) / float(MIX_RATE)
		var env: float = 1.0
		if t_time < attack:
			env = t_time / max(attack, 0.0001)
		elif t_time > duration - decay:
			env = max((duration - t_time) / max(decay, 0.0001), 0.0)
		samples[i] = raw * env * volume
	return samples


func _concat(parts: Array) -> PackedFloat32Array:
	var total: int = 0
	for p in parts:
		total += p.size()
	var out: PackedFloat32Array = PackedFloat32Array()
	out.resize(total)
	var offset: int = 0
	for p in parts:
		for i in range(p.size()):
			out[offset + i] = p[i]
		offset += p.size()
	return out


func _mix(a: PackedFloat32Array, b: PackedFloat32Array, b_gain: float = 1.0) -> PackedFloat32Array:
	var n: int = max(a.size(), b.size())
	var out: PackedFloat32Array = PackedFloat32Array()
	out.resize(n)
	for i in range(n):
		var va: float = a[i] if i < a.size() else 0.0
		var vb: float = b[i] if i < b.size() else 0.0
		out[i] = clampf(va + vb * b_gain, -1.0, 1.0)
	return out


func _make_wav(samples: PackedFloat32Array) -> AudioStreamWAV:
	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(samples.size() * 2)
	for i in range(samples.size()):
		var v: float = clampf(samples[i], -1.0, 1.0)
		var s: int = int(round(v * 32767.0))
		var u: int = s & 0xFFFF
		bytes[i * 2] = u & 0xFF
		bytes[i * 2 + 1] = (u >> 8) & 0xFF
	wav.data = bytes
	return wav


# ---------------------------------------------------------------------------
# Bibliotheque d'effets sonores
# ---------------------------------------------------------------------------

func _build_sfx_library() -> void:
	_sfx_streams["star"] = _make_wav(_gen_tone(880.0, 1320.0, 0.11, "sine", 0.004, 0.09, 0.55))
	_sfx_streams["heart"] = _make_wav(_concat([
		_gen_tone(660.0, 660.0, 0.09, "sine", 0.004, 0.06, 0.4),
		_gen_tone(990.0, 990.0, 0.15, "sine", 0.004, 0.12, 0.42),
	]))
	_sfx_streams["laser"] = _make_wav(_gen_tone(1300.0, 500.0, 0.07, "sine", 0.002, 0.06, 0.22))
	_sfx_streams["hit_meteor"] = _make_wav(_mix(
		_gen_tone(0.0, 0.0, 0.22, "noise", 0.001, 0.2, 0.28),
		_gen_tone(160.0, 55.0, 0.22, "sine", 0.001, 0.2, 1.0), 0.55
	))
	_sfx_streams["hurt"] = _make_wav(_gen_tone(320.0, 110.0, 0.16, "square", 0.002, 0.14, 0.2))
	_sfx_streams["shield"] = _make_wav(_gen_tone(700.0, 900.0, 0.08, "triangle", 0.003, 0.07, 0.2))
	_sfx_streams["enemy_kill"] = _make_wav(_mix(
		_gen_tone(0.0, 0.0, 0.14, "noise", 0.001, 0.12, 0.2),
		_gen_tone(500.0, 180.0, 0.14, "sine", 0.001, 0.12, 1.0), 0.4
	))
	_sfx_streams["boss_hit"] = _make_wav(_gen_tone(220.0, 140.0, 0.07, "square", 0.002, 0.06, 0.2))
	_sfx_streams["boss_defeat"] = _make_wav(_mix(
		_gen_tone(0.0, 0.0, 0.9, "noise", 0.001, 0.85, 0.3),
		_gen_tone(220.0, 40.0, 0.9, "sine", 0.001, 0.85, 1.0), 0.6
	))
	_sfx_streams["combo"] = _make_wav(_concat([
		_gen_tone(660.0, 660.0, 0.065, "sine", 0.002, 0.045, 0.28),
		_gen_tone(880.0, 880.0, 0.065, "sine", 0.002, 0.045, 0.3),
		_gen_tone(1100.0, 1100.0, 0.1, "sine", 0.002, 0.08, 0.32),
	]))
	_sfx_streams["button"] = _make_wav(_gen_tone(500.0, 700.0, 0.045, "sine", 0.002, 0.035, 0.2))
	_sfx_streams["zone"] = _make_wav(_gen_tone(220.0, 880.0, 0.8, "sine", 0.02, 0.6, 0.26))
	_sfx_streams["purchase"] = _make_wav(_concat([
		_gen_tone(520.0, 520.0, 0.08, "sine", 0.003, 0.06, 0.28),
		_gen_tone(780.0, 780.0, 0.16, "sine", 0.003, 0.13, 0.3),
	]))
	_sfx_streams["pause"] = _make_wav(_gen_tone(440.0, 330.0, 0.09, "sine", 0.003, 0.08, 0.22))
	_sfx_streams["game_over"] = _make_wav(_gen_tone(440.0, 110.0, 0.7, "sine", 0.01, 0.6, 0.28))
	_sfx_streams["life_lost"] = _make_wav(_gen_tone(380.0, 200.0, 0.25, "triangle", 0.004, 0.2, 0.28))
	_sfx_streams["daily_reward"] = _make_wav(_concat([
		_gen_tone(523.25, 523.25, 0.09, "triangle", 0.003, 0.07, 0.28),
		_gen_tone(659.25, 659.25, 0.09, "triangle", 0.003, 0.07, 0.3),
		_gen_tone(783.99, 783.99, 0.2, "triangle", 0.003, 0.16, 0.32),
	]))
	# --- Cinematiques ---
	_sfx_streams["whoosh"] = _make_wav(_mix(
		_gen_tone(300.0, 1600.0, 0.7, "sine", 0.05, 0.5, 0.28),
		_gen_tone(0.0, 0.0, 0.7, "noise", 0.02, 0.6, 0.1), 0.5
	))
	_sfx_streams["alarm"] = _make_wav(_concat([
		_gen_tone(660.0, 660.0, 0.3, "square", 0.01, 0.2, 0.16),
		_gen_tone(440.0, 440.0, 0.3, "square", 0.01, 0.2, 0.16),
		_gen_tone(660.0, 660.0, 0.3, "square", 0.01, 0.2, 0.16),
		_gen_tone(440.0, 440.0, 0.3, "square", 0.01, 0.2, 0.16),
	]))
	_sfx_streams["title_slam"] = _make_wav(_mix(
		_gen_tone(90.0, 50.0, 0.5, "sine", 0.002, 0.4, 0.5),
		_gen_tone(0.0, 0.0, 0.4, "noise", 0.001, 0.35, 0.2), 0.6
	))
	_sfx_streams["blip"] = _make_wav(_gen_tone(880.0, 990.0, 0.06, "sine", 0.002, 0.05, 0.18))
	_sfx_streams["hyperspace"] = _make_wav(_mix(
		_gen_tone(200.0, 2200.0, 1.0, "sine", 0.1, 0.8, 0.3),
		_gen_tone(0.0, 0.0, 1.0, "noise", 0.05, 0.9, 0.12), 0.6
	))
	_sfx_streams["boom"] = _make_wav(_mix(
		_gen_tone(120.0, 30.0, 1.2, "sine", 0.002, 1.1, 0.6),
		_gen_tone(0.0, 0.0, 1.2, "noise", 0.001, 1.15, 0.35), 0.7
	))


# ---------------------------------------------------------------------------
# Musique d'ambiance (boucle generee une seule fois)
# ---------------------------------------------------------------------------

func _build_music_loop() -> void:
	var scale: Array[float] = [220.0, 246.94, 261.63, 293.66, 329.63, 392.0]
	var pattern: Array[int] = [0, 2, 4, 3, 1, 2, 5, 3]
	var beat_dur: float = 0.42

	var parts: Array = []
	for step in pattern:
		var freq: float = scale[step]
		parts.append(_gen_tone(freq, freq, beat_dur, "triangle", 0.02, beat_dur * 0.8, 0.15))
	var melody: PackedFloat32Array = _concat(parts)

	var bass: PackedFloat32Array = _gen_tone(110.0, 110.0, beat_dur * pattern.size(), "sine", 0.05, beat_dur * 0.9, 0.1)
	var loop: PackedFloat32Array = _mix(melody, bass, 1.0)

	_music_loop = _make_wav(loop)
	_music_loop.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_music_loop.loop_begin = 0
	_music_loop.loop_end = loop.size()


# ---------------------------------------------------------------------------
# Ambiance de gameplay : hum des moteurs + souffle spatial, en boucle
# ---------------------------------------------------------------------------

func _build_ambient_loop() -> void:
	# Hum des moteurs : basse continue + legere modulation
	var hum: PackedFloat32Array = _gen_tone(55.0, 55.0, 6.4, "sine", 1.5, 1.0, 0.5)
	hum = _mix(hum, _gen_tone(58.0, 58.0, 6.4, "sine", 1.5, 1.0, 0.28), 1.0)
	# Souffle spatial : bruit doux et lent
	var space: PackedFloat32Array = _gen_tone(0.0, 0.0, 6.4, "noise", 2.0, 2.0, 0.08)
	var loop: PackedFloat32Array = _mix(hum, space, 0.6)
	# Enveloppe de respiration (monte/descend lentement pour eviter le mur statique)
	var n: int = loop.size()
	for i in range(n):
		var frac: float = float(i) / float(n)
		var breathe: float = 0.8 + 0.2 * sin(frac * TAU * 2.0)
		loop[i] = clampf(loop[i] * breathe, -1.0, 1.0)
	_ambient_loop = _make_wav(loop)
	_ambient_loop.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_ambient_loop.loop_begin = 0
	_ambient_loop.loop_end = loop.size()


# ---------------------------------------------------------------------------
# Assets externes (fichiers ogg/wav/mp3 generes par IA dans assets/audio/)
# ---------------------------------------------------------------------------

func _try_load_external_assets() -> void:
	"""Si des fichiers audio existent dans res://assets/audio/, on les charge et
	ils remplacent les versions synthetisees. Les fichiers sont attendus avec des
	noms fixes : music_loop.ogg, ambient_loop.ogg, cine_ambient.ogg,
	cine_tension.ogg, cine_victory.ogg, cine_warp.ogg, et sfx_<nom>.ogg."""
	if not DirAccess.dir_exists_absolute("res://assets/audio"):
		return
	var dir: DirAccess = DirAccess.open("res://assets/audio")
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and (file_name.ends_with(".ogg") or file_name.ends_with(".wav") or file_name.ends_with(".mp3")):
			var path: String = "res://assets/audio/" + file_name
			var stream: AudioStream = load(path)
			if stream != null:
				_external_streams[file_name.get_basename()] = stream
		file_name = dir.get_next()
	dir.list_dir_end()
	if _external_streams.has("music_loop"):
		_music_loop = _external_streams["music_loop"]
	if _external_streams.has("ambient_loop"):
		_ambient_loop = _external_streams["ambient_loop"]
	for mood in ["ambient", "tension", "victory", "warp"]:
		var key: String = "cine_" + mood
		if _external_streams.has(key):
			_cine_loops[mood] = _external_streams[key]
	# Les SFX externes (sfx_laser.ogg -> "laser", sfx_whoosh.ogg -> "whoosh")
	for name in _external_streams.keys():
		if name.begins_with("sfx_"):
			_sfx_streams[name.trim_prefix("sfx_")] = _external_streams[name]
