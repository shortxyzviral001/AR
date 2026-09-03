extends Node2D

# ---------------------------------------------------------------------------
# Textures
# ---------------------------------------------------------------------------
const PLAYER_TEXTURE: Texture2D = preload("res://assets/player_ship.png")
const HULL_TEXTURE_INTERCEPTEUR: Texture2D = preload("res://assets/hull_intercepteur.png")
const HULL_TEXTURE_BOMBARDIER: Texture2D = preload("res://assets/hull_bombardier.png")
const HULL_TEXTURE_FURTIF: Texture2D = preload("res://assets/hull_furtif.png")
const HULL_TEXTURE_LEGENDAIRE: Texture2D = preload("res://assets/hull_legendaire.png")

const BADGE_ICON_TEXTURES: Dictionary = {
	"comete": preload("res://assets/badge_comete.png"),
	"meteore": preload("res://assets/badge_meteore.png"),
	"etoile_filante": preload("res://assets/badge_etoile_filante.png"),
	"nebuleuse": preload("res://assets/badge_nebuleuse.png"),
	"satellite": preload("res://assets/badge_satellite.png"),
	"pulsar": preload("res://assets/badge_pulsar.png"),
	"trou_noir": preload("res://assets/badge_trou_noir.png"),
	"supernova": preload("res://assets/badge_supernova.png"),
	"constellation": preload("res://assets/badge_constellation.png"),
	"couronne": preload("res://assets/badge_couronne.png"),
}

const TRAIL_ICON_TEXTURES: Dictionary = {
	"dust": preload("res://assets/trail_dust.svg"),
	"sparkle": preload("res://assets/trail_sparkle.svg"),
	"stream": preload("res://assets/trail_stream.svg"),
	"smoke": preload("res://assets/trail_smoke.svg"),
	"flame": preload("res://assets/trail_flame.svg"),
	"ring": preload("res://assets/trail_ring.svg"),
}
const STAR_TEXTURE: Texture2D = preload("res://assets/star.svg")
const METEOR_TEXTURE: Texture2D = preload("res://assets/meteor.svg")
const HEART_TEXTURE: Texture2D = preload("res://assets/heart.svg")
const ENEMY_TEXTURE: Texture2D = preload("res://assets/enemy_ship.png")
const BOSS_TEXTURE: Texture2D = preload("res://assets/boss_ship.png")
const PLAYER_BOLT_TEXTURE: Texture2D = preload("res://assets/player_bolt.svg")
const ENEMY_BOLT_TEXTURE: Texture2D = preload("res://assets/enemy_bolt.svg")
const GEAR_ICON_TEXTURE: Texture2D = preload("res://assets/gear_icon.svg")
const PAUSE_ICON_TEXTURE: Texture2D = preload("res://assets/pause_triangle_icon.svg")
const STARFIELD_SCRIPT: Script = preload("res://scripts/Starfield.gd")

# AI-generated backgrounds (Pollinations, free public API) — see assets/cine + assets/zones
const CINE_BG_HARVEST: Texture2D = preload("res://assets/cine/cine_bg_harvest.jpg")
const CINE_BG_SIGNAL: Texture2D = preload("res://assets/cine/cine_bg_signal.jpg")
const CINE_BG_SCOURGE: Texture2D = preload("res://assets/cine/cine_bg_scourge.jpg")
const CINE_BG_LAUNCH: Texture2D = preload("res://assets/cine/cine_bg_launch.jpg")
const CINE_BG_INTRO: Texture2D = preload("res://assets/cine/cine_bg_intro.jpg")
const MENU_BG_TEXTURE: Texture2D = preload("res://assets/menu_bg.jpg")
const BTN_PRIMARY_TEXTURE: Texture2D = preload("res://assets/btn_primary.png")
const BTN_SECONDARY_TEXTURE: Texture2D = preload("res://assets/btn_secondary.png")
const TITLE_LOGO_TEXTURE: Texture2D = preload("res://assets/title_logo.png")
const ZONE_BG_TEXTURES: Array[Texture2D] = [
	preload("res://assets/zones/zone_bg_blue.jpg"),
	preload("res://assets/zones/zone_bg_violet.jpg"),
	preload("res://assets/zones/zone_bg_amber.jpg"),
	preload("res://assets/zones/zone_bg_crimson.jpg"),
	preload("res://assets/zones/zone_bg_emerald.jpg"),
]
const TOUCH_CONTROLS_SCRIPT: Script = preload("res://scripts/TouchControls.gd")

# ---------------------------------------------------------------------------
# Gameplay constants
# ---------------------------------------------------------------------------
const PLAYER_SPEED: float = 620.0
const PLAYER_MARGIN: float = 42.0
const TOP_MARGIN: float = 76.0
const DIFFICULTY_TIME_DIVISOR: float = 9.0
const SLOW_SPEED_MULT: float = 0.5
const SAVE_PATH: String = "user://astro_recolte.save"
const ADS_DEBUG_VISIBLE: bool = false
const PLAYER_INVULN_TIME: float = 0.9
const SHIELD_POWERUP_TIME: float = 3.5
const SPEED_POWERUP_TIME: float = 4.0
const SPEED_POWERUP_MULT: float = 1.45
const POWERUP_CHANCE: float = 0.06

# Random pseudo generator
const PSEUDO_ADJECTIVES: Array[String] = [
	"Cosmic", "Stellar", "Nova", "Lunar", "Solar", "Orbital",
	"Quantum", "Nebula", "Galactic", "Astral", "Void", "Dark",
	"Bright", "Swift", "Bold", "Lucky", "Storm", "Plasma",
	"Cyber", "Astro", "Rocket", "Atomic", "Glitch", "Hyper",
]
const PSEUDO_NOUNS: Array[String] = [
	"Pilot", "Rider", "Hunter", "Ace", "Ghost", "Star",
	"Ray", "Drift", "Spark", "Wolf", "Fox", "Hawk",
	"Blaze", "Fury", "Storm", "Core", "Beam", "Warp",
	"Bolt", "Wave", "Flux", "Nebula", "Comet", "Orbit",
]

const LAYER_PLAYER: int = 1
const LAYER_FALLING: int = 2
const LAYER_ENEMY: int = 4
const LAYER_ENEMY_BULLET: int = 8
const LAYER_PLAYER_BULLET: int = 16

const PLAYER_FIRE_INTERVAL: float = 0.26
const PLAYER_LASER_SPEED: float = 820.0
const PLAYER_LASER_DAMAGE: float = 1.0

const ENEMY_GRACE_TIME: float = 8.0
const ENEMY_SPAWN_INTERVAL_BASE: float = 2.6
const ENEMY_SPAWN_INTERVAL_MIN: float = 1.15
const ENEMY_FALL_SPEED_MIN: float = 95.0
const ENEMY_FALL_SPEED_MAX: float = 150.0
const ENEMY_WEAVE_AMPLITUDE: float = 60.0
const ENEMY_WEAVE_FREQ: float = 2.1
const ENEMY_BULLET_SPEED: float = 260.0

const BOSS_BASE_HP: float = 42.0
const BOSS_HP_PER_ZONE: float = 16.0
const BOSS_FIRE_INTERVAL_BASE: float = 1.9
const BOSS_FIRE_INTERVAL_MIN: float = 1.05
const BOSS_HOVER_Y: float = 150.0
const BOSS_ENTRY_SPEED: float = 220.0
const BOSS_BULLET_BASE_COUNT: int = 3
const BOSS_DEFEAT_REWARD_BASE: int = 220
const BOSS_DEFEAT_REWARD_PER_ZONE: int = 70

const ZONE_BOSS_TRIGGER_BASE: float = 38.0
const ZONE_BOSS_TRIGGER_PER_ZONE: float = 6.0
const ZONE_SPEED_MULT_STEP: float = 0.10
const ZONE_SPEED_MULT_MAX: float = 1.5

const ZONE_THEMES: Array[Dictionary] = [
	{"name": "Ceinture Bleue", "bg": Color("#07101f"), "star_tint": Color(1.0, 1.0, 1.0), "meteor_tint": Color(1.0, 1.0, 1.0), "boss_name": "Sentinelle Azur"},
	{"name": "Nebuleuse Violette", "bg": Color("#150b28"), "star_tint": Color(0.82, 0.68, 1.15), "meteor_tint": Color(0.88, 0.78, 1.15), "boss_name": "Devoreur Pourpre"},
	{"name": "Ceinture Ambree", "bg": Color("#201207"), "star_tint": Color(1.15, 0.92, 0.65), "meteor_tint": Color(1.15, 0.98, 0.72), "boss_name": "Colosse Ambre"},
	{"name": "Zone Cramoisie", "bg": Color("#240710"), "star_tint": Color(1.2, 0.68, 0.72), "meteor_tint": Color(1.2, 0.72, 0.78), "boss_name": "Faucheur Ecarlate"},
	{"name": "Abysses Emeraude", "bg": Color("#041a14"), "star_tint": Color(0.68, 1.15, 0.9), "meteor_tint": Color(0.72, 1.2, 0.95), "boss_name": "Gardien Emeraude"},
]

# ---------------------------------------------------------------------------
# Modern UI color palette -- "Aurore" (cyan-violet) + or chaud
# ---------------------------------------------------------------------------
const COL_PANEL_BG: Color = Color(0.035, 0.045, 0.12, 0.94)
const COL_PANEL_BORDER: Color = Color(0.42, 0.50, 0.96, 0.50)
const COL_BTN_NORMAL: Color = Color(0.09, 0.11, 0.24, 0.96)
const COL_BTN_HOVER: Color = Color(0.14, 0.17, 0.34, 0.98)
const COL_BTN_PRIMARY: Color = Color(0.30, 0.34, 0.86, 0.95)
const COL_BTN_PRIMARY_HOVER: Color = Color(0.38, 0.50, 0.95, 0.98)
const COL_BTN_PRIMARY_PRESS: Color = Color(0.20, 0.24, 0.62, 0.98)
const COL_BTN_DANGER: Color = Color(0.75, 0.18, 0.22, 0.9)
const COL_ACCENT: Color = Color("#35e6c9")
const COL_ACCENT_DIM: Color = Color("#1f9e8f")
const COL_VIOLET: Color = Color("#7c5cff")
const COL_GOLD: Color = Color("#ffcf6b")
const COL_TEXT: Color = Color("#eef4ff")
const COL_TEXT_DIM: Color = Color("#96a3cc")
const COL_SECTION: Color = Color("#35e6c9")
const COL_SHADE: Color = Color(0.005, 0.01, 0.03, 0.78)
const COL_HUD_BG: Color = Color(0.02, 0.04, 0.10, 0.88)


# ---------------------------------------------------------------------------
# Runtime state
# ---------------------------------------------------------------------------
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _player: Area2D
var _player_sprite: Sprite2D
var _player_trail: CPUParticles2D
var _player_shield: CPUParticles2D
var _player_base_tint: Color = Color.WHITE
var _touch_controls
var _spawn_timer: Timer
var _camera: Camera2D
var _hud_score: Label
var _hud_lives: Label
var _hud_time: Label
var _hud_currency: Label

# Menu screens
var _menu_root: Control
var _menu_shade: ColorRect
var _menu_background: TextureRect
var _screen_language: Control
var _screen_start: Control
var _screen_pseudo: Control
var _screen_game_over: Control
var _screen_leaderboard: Control
var _screen_settings: Control
var _screen_shop: Control
var _screen_credits: Control
var _screen_tutorial: Control
var _screen_consent: Control

var _start_body: Label
var _daily_reward_label: Label
var _daily_reward_amount: int = 0
var _play_button: Button

var _pseudo_input: LineEdit
var _pseudo_feedback: Label
var _pseudo_confirm_button: Button

var _game_over_body: Label
var _game_over_status: Label
var _replay_button: Button
var _rewarded_button: Button
var _consent_accept_button: Button
var _consent_decline_button: Button
var _ads_status_label: Label
var _ads_debug_label: Label
var _ads_status_timer: float = 0.0
var _run_bonus: int = 0
var _reward_claimed: bool = false

var _leaderboard_status: Label
var _leaderboard_list: RichTextLabel

var _difficulty_option: OptionButton
var _touch_toggle: CheckButton
var _sfx_toggle: CheckButton
var _music_toggle: CheckButton
var _reduce_motion_toggle: CheckButton
var _high_contrast_toggle: CheckButton
var _ads_consent_toggle: CheckButton
var _music_volume_slider: HSlider
var _sfx_volume_slider: HSlider
var _cine_volume_slider: HSlider
var _music_volume_label: Label
var _sfx_volume_label: Label
var _cine_volume_label: Label
var _reset_score_button: Button
var _settings_progress_label: Label
var _language_option: OptionButton

var _return_screen: Control

var _score: int = 0
var _lives: int = 3
var _elapsed: float = 0.0
var _difficulty: float = 0.0
var _slow_time_left: float = 0.0
var _invuln_time: float = 0.0
var _shield_time_left: float = 0.0
var _speed_time_left: float = 0.0
var _combo: int = 0
var _paused: bool = false
var _screen_pause: Control
var _pause_status_label: Label
var _settings_return_to_pause: bool = false
var _game_running: bool = false
var _shake_time: float = 0.0
var _shake_strength: float = 0.0
var _high_score: int = 0
var _awaiting_pseudo_check: bool = false

var _starfield: Node2D
var _lasers_timer: float = 0.0
var _enemy_spawn_timer: Timer

var _zone_index: int = 0
var _zone_elapsed: float = 0.0
var _zone_banner: Label
var _zone_banner_timer: float = 0.0

var _boss: Area2D = null
var _boss_sprite: Sprite2D = null
var _boss_state: String = ""
var _boss_fire_timer: float = 0.0
var _boss_pattern_step: int = 0
var _boss_name_label: Label
var _boss_bar_bg: ColorRect
var _boss_bar_fill: ColorRect

# Combo HUD
var _combo_hud_label: Label
var _combo_hud_bar: ColorRect
var _combo_hud_bar_bg: ColorRect

# Boss victory
var _boss_victory_label: Label
var _boss_victory_sub: Label
var _boss_flash_rect: ColorRect

# Ad countdown
var _ad_countdown_label: Label
var _ad_continue_button: Button
var _ad_check_start: float = 0.0
var _interstitial_prompt: PanelContainer

# Run stats
var _run_crystals: int = 0
var _run_boss_kills: int = 0

# Cinematic state
var _cinematic_active: bool = false
var _story_panel_index: int = 0
var _cine_skip_button: Button = null
var _cine_overlay: ColorRect
var _cine_bg: TextureRect  # AI-generated background shown behind cinematic elements
var _cine_title_label: Label
var _cine_subtitle_label: Label

# Story cinematic (dialogue system)
var _cine_dialogue_panel: PanelContainer = null
var _cine_dialogue_name: Label = null
var _cine_dialogue_text: Label = null
var _cine_dialogue_hint: Label = null
var _cine_story_tweens: Array = []

# Update banner
var _update_banner: PanelContainer
var _update_banner_label: Label
var _update_dialog: PanelContainer
var _update_dialog_visible: bool = false

# ---------------------------------------------------------------------------
# Lifecycle
# ---------------------------------------------------------------------------

func _ready() -> void:
	_rng.randomize()
	_load_high_score()
	_register_controls()
	_build_scene()
	_daily_reward_amount = Shop.claim_daily_reward()
	AdsManager.reload_rewarded()
	UpdateChecker.check_for_update()

	Leaderboard.pseudo_check_result.connect(_on_pseudo_check_result)
	Leaderboard.score_submit_result.connect(_on_score_submit_result)
	Leaderboard.leaderboard_ready.connect(_on_leaderboard_ready)

	# Language selection: shown once if not yet chosen.
	if Settings.language == "":
		_show_screen(_screen_language)
	elif Leaderboard.has_pseudo():
		_show_start()
	else:
		_open_pseudo_screen()


func _process(delta: float) -> void:
	_update_camera(delta)
	_ads_status_timer += delta
	if _ads_status_timer >= 2.0:
		_ads_status_timer = 0.0
		_refresh_ads_status()
	if not _game_running or _paused:
		return
	_elapsed += delta
	if _slow_time_left > 0.0:
		_slow_time_left = max(_slow_time_left - delta, 0.0)
	if _invuln_time > 0.0:
		_invuln_time = max(_invuln_time - delta, 0.0)
	if _shield_time_left > 0.0:
		_shield_time_left = max(_shield_time_left - delta, 0.0)
	if _speed_time_left > 0.0:
		_speed_time_left = max(_speed_time_left - delta, 0.0)
	_difficulty = clampf((_elapsed / DIFFICULTY_TIME_DIVISOR) * Settings.speed_multiplier(), 0.0, Settings.max_difficulty())
	_move_player(delta)
	_move_falling_objects(delta)
	_update_player_lasers(delta)
	_move_enemies(delta)
	_move_enemy_bullets(delta)
	_update_boss(delta)
	_update_zone(delta)
	_update_zone_banner(delta)
	_update_hud()


func _build_scene() -> void:
	var starfield: Node2D = Node2D.new()
	starfield.name = "Starfield"
	starfield.set_script(STARFIELD_SCRIPT)
	add_child(starfield)
	_starfield = starfield

	_camera = Camera2D.new()
	_camera.name = "Camera2D"
	_camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	_camera.position = Vector2.ZERO
	_camera.enabled = true
	add_child(_camera)

	_create_player()
	_create_hud()
	_create_menu()
	_apply_accessibility_visuals()

	_touch_controls = CanvasLayer.new()
	_touch_controls.name = "TouchControls"
	_touch_controls.set_script(TOUCH_CONTROLS_SCRIPT)
	add_child(_touch_controls)
	_touch_controls.visible = false

	_spawn_timer = Timer.new()
	_spawn_timer.name = "SpawnTimer"
	_spawn_timer.one_shot = false
	_spawn_timer.timeout.connect(_spawn_falling_object)
	add_child(_spawn_timer)

	_enemy_spawn_timer = Timer.new()
	_enemy_spawn_timer.name = "EnemySpawnTimer"
	_enemy_spawn_timer.one_shot = false
	_enemy_spawn_timer.timeout.connect(_maybe_spawn_enemy)
	add_child(_enemy_spawn_timer)

	_apply_zone(0, false)


# ---------------------------------------------------------------------------
# Player
# ---------------------------------------------------------------------------

func _create_player() -> void:
	_player = Area2D.new()
	_player.name = "Player"
	_player.collision_layer = 1
	_player.collision_mask = 2

	var trail: CPUParticles2D = CPUParticles2D.new()
	trail.name = "Trail"
	trail.emitting = true
	trail.direction = Vector2(0.0, 1.0)
	trail.position = Vector2(0.0, 24.0)
	trail.color = Shop.equipped_trail_color()
	_configure_trail_style(trail, Shop.equipped_trail_style())
	_player.add_child(trail)
	_player_trail = trail

	var shield: CPUParticles2D = CPUParticles2D.new()
	shield.name = "Shield"
	shield.emitting = false
	shield.direction = Vector2(0.0, -1.0)
	shield.position = Vector2(0.0, 0.0)
	shield.amount = 12
	shield.lifetime = 0.6
	shield.spread = 360.0
	shield.initial_velocity_min = 15.0
	shield.initial_velocity_max = 40.0
	shield.scale_amount_min = 2.0
	shield.scale_amount_max = 4.0
	shield.color = Color(0.3, 0.85, 1.0)
	_player.add_child(shield)
	_player_shield = shield

	var sprite: Sprite2D = Sprite2D.new()
	var silhouette0: String = Shop.equipped_hull_silhouette()
	sprite.texture = _hull_texture_for(silhouette0)
	# Textures peintes (PNG) plus grandes en resolution native que les
	# anciens SVG vectoriels -- 0.29 conserve la meme taille a l'ecran.
	sprite.scale = Vector2(0.29, 0.29)
	_player_base_tint = _hull_tint_for(silhouette0, Shop.equipped_hull_color())
	sprite.modulate = _player_base_tint
	_player.add_child(sprite)
	_player_sprite = sprite

	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 31.0
	shape.shape = circle
	_player.add_child(shape)

	add_child(_player)
	_reset_player_position()


func _hull_texture_for(silhouette: String) -> Texture2D:
	match silhouette:
		"intercepteur": return HULL_TEXTURE_INTERCEPTEUR
		"bombardier": return HULL_TEXTURE_BOMBARDIER
		"furtif": return HULL_TEXTURE_FURTIF
		"legendaire": return HULL_TEXTURE_LEGENDAIRE
		_: return PLAYER_TEXTURE


# La coque "legendaire" est peinte en or/ivoire fixe (pas une silhouette
# neutre) : on ne la teinte jamais dynamiquement pour conserver son rendu
# tel que dessine, quelle que soit la couleur de finition equipee/prevue.
func _hull_tint_for(silhouette: String, base_color: Color) -> Color:
	if silhouette == "legendaire":
		return Color.WHITE
	return base_color


func _configure_trail_style(trail: CPUParticles2D, style: String) -> void:
	trail.texture = null
	if style == "sparkle":
		trail.texture = STAR_TEXTURE
		trail.amount = 20; trail.lifetime = 0.5; trail.spread = 30.0
		trail.initial_velocity_min = 30.0; trail.initial_velocity_max = 80.0
		trail.scale_amount_min = 0.06; trail.scale_amount_max = 0.12
	elif style == "stream":
		trail.amount = 26; trail.lifetime = 0.4; trail.spread = 6.0
		trail.initial_velocity_min = 90.0; trail.initial_velocity_max = 140.0
		trail.scale_amount_min = 1.4; trail.scale_amount_max = 2.4
	elif style == "smoke":
		trail.amount = 20; trail.lifetime = 0.85; trail.spread = 26.0
		trail.initial_velocity_min = 20.0; trail.initial_velocity_max = 55.0
		trail.scale_amount_min = 3.0; trail.scale_amount_max = 6.0
	elif style == "flame":
		trail.amount = 26; trail.lifetime = 0.35; trail.spread = 12.0
		trail.initial_velocity_min = 70.0; trail.initial_velocity_max = 130.0
		trail.scale_amount_min = 2.4; trail.scale_amount_max = 4.6
	elif style == "ring":
		trail.amount = 22; trail.lifetime = 0.6; trail.spread = 55.0
		trail.initial_velocity_min = 35.0; trail.initial_velocity_max = 70.0
		trail.scale_amount_min = 1.8; trail.scale_amount_max = 3.2
	else:
		trail.amount = 16; trail.lifetime = 0.5; trail.spread = 22.0
		trail.initial_velocity_min = 20.0; trail.initial_velocity_max = 50.0
		trail.scale_amount_min = 1.5; trail.scale_amount_max = 2.6


func _apply_equipped_cosmetics() -> void:
	var silhouette1: String = Shop.equipped_hull_silhouette()
	_player_base_tint = _hull_tint_for(silhouette1, Shop.equipped_hull_color())
	if _player_sprite != null and _invuln_time <= 0.0 and _slow_time_left <= 0.0:
		_player_sprite.modulate = _player_base_tint
	if _player_sprite != null:
		_player_sprite.texture = _hull_texture_for(silhouette1)
	if _player_trail != null:
		_player_trail.color = Shop.equipped_trail_color()
		_configure_trail_style(_player_trail, Shop.equipped_trail_style())


# ---------------------------------------------------------------------------
# HUD
# ---------------------------------------------------------------------------

func _create_hud() -> void:
	var layer: CanvasLayer = CanvasLayer.new()
	layer.name = "HUD"
	add_child(layer)

	var bar: Panel = Panel.new()
	bar.name = "TopBar"
	var bar_style: StyleBoxFlat = StyleBoxFlat.new()
	bar_style.bg_color = COL_HUD_BG
	bar_style.corner_radius_bottom_left = 16
	bar_style.corner_radius_bottom_right = 16
	bar_style.border_width_bottom = 2
	bar_style.border_color = COL_PANEL_BORDER
	bar.add_theme_stylebox_override("panel", bar_style)
	bar.anchor_right = 1.0
	bar.custom_minimum_size = Vector2(0.0, 64.0)
	bar.size = Vector2(get_viewport_rect().size.x, 64.0)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(bar)

	var row: HBoxContainer = HBoxContainer.new()
	row.name = "Counters"
	row.anchor_right = 1.0
	row.offset_left = 18.0; row.offset_top = 15.0; row.offset_right = -96.0; row.offset_bottom = 49.0
	row.add_theme_constant_override("separation", 22)
	layer.add_child(row)

	var score_stat: Dictionary = _make_hud_stat(Color("#fff17a"))
	row.add_child(score_stat.container)
	_hud_score = score_stat.label

	var lives_stat: Dictionary = _make_hud_stat(Color("#8effc8"))
	row.add_child(lives_stat.container)
	_hud_lives = lives_stat.label

	var time_stat: Dictionary = _make_hud_stat(Color("#8fb8ff"))
	row.add_child(time_stat.container)
	_hud_time = time_stat.label

	var currency_stat: Dictionary = _make_hud_stat(COL_GOLD)
	row.add_child(currency_stat.container)
	_hud_currency = currency_stat.label
	_hud_currency.add_theme_color_override("font_color", COL_GOLD)

	# --- Pause button (MOBILE FIX: larger touch area 48x48 minimum) ---
	var pause_button: TextureButton = _make_icon_button(PAUSE_ICON_TEXTURE)
	pause_button.name = "PauseButton"
	pause_button.anchor_left = 1.0; pause_button.anchor_right = 1.0
	pause_button.offset_left = -92.0; pause_button.offset_right = -48.0
	pause_button.offset_top = 10.0; pause_button.offset_bottom = 54.0
	pause_button.pressed.connect(_toggle_pause)
	layer.add_child(pause_button)

	# --- Settings button (MOBILE FIX: larger touch area) ---
	var settings_button: TextureButton = _make_icon_button(GEAR_ICON_TEXTURE)
	settings_button.name = "SettingsButton"
	settings_button.anchor_left = 1.0; settings_button.anchor_right = 1.0
	settings_button.offset_left = -46.0; settings_button.offset_right = -2.0
	settings_button.offset_top = 10.0; settings_button.offset_bottom = 54.0
	settings_button.pressed.connect(_open_gameplay_settings)
	layer.add_child(settings_button)

	_zone_banner = Label.new()
	_zone_banner.name = "ZoneBanner"
	_zone_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_zone_banner.anchor_left = 0.5; _zone_banner.anchor_right = 0.5
	_zone_banner.offset_left = -260.0; _zone_banner.offset_right = 260.0; _zone_banner.offset_top = 72.0
	_zone_banner.add_theme_font_size_override("font_size", 24)
	_zone_banner.add_theme_color_override("font_color", Color("#ffe9a8"))
	_zone_banner.add_theme_constant_override("outline_size", 6)
	_zone_banner.add_theme_color_override("font_outline_color", Color(0.03, 0.02, 0.05, 0.9))
	_zone_banner.modulate.a = 0.0
	layer.add_child(_zone_banner)

	_boss_name_label = Label.new()
	_boss_name_label.name = "BossName"
	_boss_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_boss_name_label.anchor_left = 0.5; _boss_name_label.anchor_right = 0.5
	_boss_name_label.offset_left = -220.0; _boss_name_label.offset_right = 220.0; _boss_name_label.offset_top = 66.0
	_boss_name_label.add_theme_font_size_override("font_size", 16)
	_boss_name_label.add_theme_color_override("font_color", Color("#ffd0d8"))
	layer.add_child(_boss_name_label)

	_boss_bar_bg = ColorRect.new()
	_boss_bar_bg.name = "BossBarBg"
	_boss_bar_bg.color = Color(0.05, 0.02, 0.04, 0.75)
	_boss_bar_bg.anchor_left = 0.5; _boss_bar_bg.anchor_right = 0.5
	_boss_bar_bg.offset_left = -170.0; _boss_bar_bg.offset_right = 170.0
	_boss_bar_bg.offset_top = 90.0; _boss_bar_bg.offset_bottom = 104.0
	layer.add_child(_boss_bar_bg)

	_boss_bar_fill = ColorRect.new()
	_boss_bar_fill.name = "BossBarFill"
	_boss_bar_fill.color = Color("#ff4d5e")
	_boss_bar_fill.anchor_left = 0.5; _boss_bar_fill.anchor_right = 0.5
	_boss_bar_fill.offset_left = -166.0; _boss_bar_fill.offset_right = 166.0
	_boss_bar_fill.offset_top = 93.0; _boss_bar_fill.offset_bottom = 101.0
	layer.add_child(_boss_bar_fill)

	_set_boss_hud_visible(false)

	# --- Combo HUD (below top bar) ---
	var combo_bg: Panel = Panel.new()
	combo_bg.name = "ComboBarBg"
	var combo_bg_style: StyleBoxFlat = StyleBoxFlat.new()
	combo_bg_style.bg_color = Color(0.01, 0.02, 0.06, 0.70)
	combo_bg_style.set_corner_radius_all(6)
	combo_bg_style.set_content_margin_all(4.0)
	combo_bg.add_theme_stylebox_override("panel", combo_bg_style)
	combo_bg.anchor_left = 0.5; combo_bg.anchor_right = 0.5
	combo_bg.offset_left = -130.0; combo_bg.offset_right = 130.0
	combo_bg.offset_top = 68.0; combo_bg.offset_bottom = 86.0
	combo_bg.modulate.a = 0.0
	layer.add_child(combo_bg)
	_combo_hud_bar_bg = ColorRect.new()
	_combo_hud_bar_bg.color = Color(0.15, 0.12, 0.04, 0.60)
	_combo_hud_bar_bg.offset_left = 6.0; _combo_hud_bar_bg.offset_right = 254.0
	_combo_hud_bar_bg.offset_top = 4.0; _combo_hud_bar_bg.offset_bottom = 14.0
	var combo_bg_radius: StyleBoxFlat = StyleBoxFlat.new()
	combo_bg_radius.set_corner_radius_all(4)
	_combo_hud_bar_bg.add_theme_stylebox_override("panel", combo_bg_radius)
	combo_bg.add_child(_combo_hud_bar_bg)
	_combo_hud_bar = ColorRect.new()
	_combo_hud_bar.color = COL_GOLD
	_combo_hud_bar.offset_left = 6.0; _combo_hud_bar.offset_right = 6.0
	_combo_hud_bar.offset_top = 4.0; _combo_hud_bar.offset_bottom = 14.0
	var combo_bar_radius: StyleBoxFlat = StyleBoxFlat.new()
	combo_bar_radius.set_corner_radius_all(4)
	_combo_hud_bar.add_theme_stylebox_override("panel", combo_bar_radius)
	combo_bg.add_child(_combo_hud_bar)
	_combo_hud_label = Label.new()
	_combo_hud_label.name = "ComboLabel"
	_combo_hud_label.text = "COMBO x0"
	_combo_hud_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_combo_hud_label.anchor_left = 0.5; _combo_hud_label.anchor_right = 0.5
	_combo_hud_label.offset_left = -130.0; _combo_hud_label.offset_right = 130.0
	_combo_hud_label.offset_top = -18.0; _combo_hud_label.offset_bottom = 0.0
	_combo_hud_label.add_theme_font_size_override("font_size", 12)
	_combo_hud_label.add_theme_color_override("font_color", COL_GOLD)
	_combo_hud_label.add_theme_constant_override("outline_size", 3)
	_combo_hud_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.8))
	combo_bg.add_child(_combo_hud_label)

	# --- Cinematic overlay (fullscreen dark + centered title + subtitle) ---
	_cine_overlay = ColorRect.new()
	_cine_overlay.name = "CineOverlay"
	_cine_overlay.color = Color(0.0, 0.0, 0.0, 0.85)
	_cine_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_cine_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cine_overlay.modulate.a = 0.0
	layer.add_child(_cine_overlay)
	_cine_title_label = Label.new()
	_cine_title_label.name = "CineTitle"
	_cine_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cine_title_label.anchor_left = 0.5; _cine_title_label.anchor_right = 0.5
	_cine_title_label.offset_left = -420.0; _cine_title_label.offset_right = 420.0
	_cine_title_label.offset_top = 200.0; _cine_title_label.offset_bottom = 280.0
	_cine_title_label.add_theme_font_size_override("font_size", 42)
	_cine_title_label.add_theme_color_override("font_color", Color("#f4fbff"))
	_cine_title_label.add_theme_constant_override("outline_size", 8)
	_cine_title_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.95))
	_cine_title_label.modulate.a = 0.0
	_cine_title_label.z_index = 200
	layer.add_child(_cine_title_label)
	_cine_subtitle_label = Label.new()
	_cine_subtitle_label.name = "CineSubtitle"
	_cine_subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cine_subtitle_label.anchor_left = 0.5; _cine_subtitle_label.anchor_right = 0.5
	_cine_subtitle_label.offset_left = -420.0; _cine_subtitle_label.offset_right = 420.0
	_cine_subtitle_label.offset_top = 290.0; _cine_subtitle_label.offset_bottom = 330.0
	_cine_subtitle_label.add_theme_font_size_override("font_size", 20)
	_cine_subtitle_label.add_theme_color_override("font_color", Color("#8fb8ff"))
	_cine_subtitle_label.add_theme_constant_override("outline_size", 5)
	_cine_subtitle_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.9))
	_cine_subtitle_label.modulate.a = 0.0
	_cine_subtitle_label.z_index = 200
	layer.add_child(_cine_subtitle_label)

	# --- Boss victory overlay ---
	_boss_flash_rect = ColorRect.new()
	_boss_flash_rect.name = "BossFlash"
	_boss_flash_rect.color = Color.WHITE
	_boss_flash_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_boss_flash_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_boss_flash_rect.modulate.a = 0.0
	layer.add_child(_boss_flash_rect)
	_boss_victory_label = Label.new()
	_boss_victory_label.name = "BossVictory"
	_boss_victory_label.text = "BOSS VAINCU !"
	_boss_victory_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_boss_victory_label.anchor_left = 0.5; _boss_victory_label.anchor_right = 0.5
	_boss_victory_label.offset_left = -300.0; _boss_victory_label.offset_right = 300.0
	_boss_victory_label.offset_top = 200.0; _boss_victory_label.offset_bottom = 260.0
	_boss_victory_label.add_theme_font_size_override("font_size", 48)
	_boss_victory_label.add_theme_color_override("font_color", COL_GOLD)
	_boss_victory_label.add_theme_constant_override("outline_size", 8)
	_boss_victory_label.add_theme_color_override("font_outline_color", Color(0.02, 0.01, 0.05, 0.95))
	_boss_victory_label.modulate.a = 0.0
	_boss_victory_label.z_index = 100
	layer.add_child(_boss_victory_label)
	_boss_victory_sub = Label.new()
	_boss_victory_sub.name = "BossVictorySub"
	_boss_victory_sub.text = "SECTEUR SUIVANT"
	_boss_victory_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_boss_victory_sub.anchor_left = 0.5; _boss_victory_sub.anchor_right = 0.5
	_boss_victory_sub.offset_left = -300.0; _boss_victory_sub.offset_right = 300.0
	_boss_victory_sub.offset_top = 265.0; _boss_victory_sub.offset_bottom = 305.0
	_boss_victory_sub.add_theme_font_size_override("font_size", 22)
	_boss_victory_sub.add_theme_color_override("font_color", Color("#b8d4ff"))
	_boss_victory_sub.add_theme_constant_override("outline_size", 5)
	_boss_victory_sub.add_theme_color_override("font_outline_color", Color(0.02, 0.01, 0.05, 0.9))
	_boss_victory_sub.modulate.a = 0.0
	_boss_victory_sub.z_index = 100
	layer.add_child(_boss_victory_sub)

	# --- Ad countdown label (bottom center, visible during rewarded ads) ---
	_ad_countdown_label = Label.new()
	_ad_countdown_label.name = "AdCountdown"
	_ad_countdown_label.text = ""
	_ad_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ad_countdown_label.anchor_left = 0.5; _ad_countdown_label.anchor_right = 0.5
	_ad_countdown_label.offset_left = -400.0; _ad_countdown_label.offset_right = 400.0
	_ad_countdown_label.offset_top = 400.0; _ad_countdown_label.offset_bottom = 430.0
	_ad_countdown_label.add_theme_font_size_override("font_size", 16)
	_ad_countdown_label.add_theme_color_override("font_color", COL_GOLD)
	_ad_countdown_label.add_theme_constant_override("outline_size", 4)
	_ad_countdown_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.9))
	_ad_countdown_label.visible = false
	layer.add_child(_ad_countdown_label)

	# --- Ad continue button (desktop: "J'ai regarde" once the 15s are up) ---
	_ad_continue_button = _make_secondary_button(Settings.loc("ad_continue"))
	_ad_continue_button.name = "AdContinue"
	_ad_continue_button.anchor_left = 0.5; _ad_continue_button.anchor_right = 0.5
	_ad_continue_button.offset_left = -150.0; _ad_continue_button.offset_right = 150.0
	_ad_continue_button.offset_top = 438.0; _ad_continue_button.offset_bottom = 486.0
	_ad_continue_button.pressed.connect(AdsManager.desktop_mark_returned)
	_ad_continue_button.visible = false
	layer.add_child(_ad_continue_button)

	# --- Interstitial prompt (top, below HUD bar) : jamais automatique --
	# Adsterra n'ayant pas de format interstitiel plein ecran natif, ceci
	# est une simple invite cliquable ; le joueur choisit d'ouvrir la pub
	# ou de l'ignorer (bouton fermer), sans jamais rediriger de force.
	_interstitial_prompt = PanelContainer.new()
	_interstitial_prompt.name = "InterstitialPrompt"
	var interstitial_sb: StyleBoxFlat = StyleBoxFlat.new()
	interstitial_sb.bg_color = Color(0.14, 0.10, 0.02, 0.94)
	interstitial_sb.set_corner_radius_all(12)
	interstitial_sb.set_border_width_all(2)
	interstitial_sb.border_color = COL_GOLD
	interstitial_sb.set_content_margin_all(10.0)
	_interstitial_prompt.add_theme_stylebox_override("panel", interstitial_sb)
	_interstitial_prompt.anchor_left = 0.5; _interstitial_prompt.anchor_right = 0.5
	_interstitial_prompt.offset_left = -170.0; _interstitial_prompt.offset_right = 170.0
	_interstitial_prompt.offset_top = 70.0; _interstitial_prompt.offset_bottom = 118.0
	_interstitial_prompt.visible = false
	_interstitial_prompt.z_index = 90
	layer.add_child(_interstitial_prompt)
	var interstitial_row: HBoxContainer = HBoxContainer.new()
	interstitial_row.add_theme_constant_override("separation", 10)
	_interstitial_prompt.add_child(interstitial_row)
	var interstitial_label: Label = Label.new()
	interstitial_label.text = Settings.loc("ad_interstitial_prompt")
	interstitial_label.add_theme_font_size_override("font_size", 13)
	interstitial_label.add_theme_color_override("font_color", COL_GOLD)
	interstitial_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	interstitial_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	interstitial_row.add_child(interstitial_label)
	var interstitial_close: Button = Button.new()
	interstitial_close.text = "✕"
	interstitial_close.custom_minimum_size = Vector2(28.0, 28.0)
	interstitial_close.pressed.connect(_dismiss_interstitial_prompt)
	interstitial_row.add_child(interstitial_close)
	_interstitial_prompt.gui_input.connect(_on_interstitial_prompt_input)


func _make_hud_label() -> Label:
	var label: Label = Label.new()
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", COL_TEXT)
	label.custom_minimum_size = Vector2(120.0, 32.0)
	return label


func _make_hud_stat(chip_color: Color) -> Dictionary:
	var capsule: HBoxContainer = HBoxContainer.new()
	capsule.add_theme_constant_override("separation", 7)
	var chip: ColorRect = ColorRect.new()
	chip.color = chip_color; chip.custom_minimum_size = Vector2(10.0, 10.0)
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var chip_wrap: CenterContainer = CenterContainer.new()
	chip_wrap.custom_minimum_size = Vector2(10.0, 32.0); chip_wrap.add_child(chip)
	capsule.add_child(chip_wrap)
	var label: Label = _make_hud_label()
	capsule.add_child(label)
	return {"container": capsule, "label": label}


func _make_icon_button(texture: Texture2D) -> TextureButton:
	var button: TextureButton = TextureButton.new()
	button.texture_normal = texture
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	# MOBILE FIX: minimum 48x48 for touch targets
	button.custom_minimum_size = Vector2(48.0, 48.0)
	button.modulate = Color(1.0, 1.0, 1.0, 0.85)
	return button


func _open_gameplay_settings() -> void:
	if not _game_running:
		return
	if not _paused:
		_paused = true
		_spawn_timer.paused = true
		_enemy_spawn_timer.paused = true
	_open_settings_screen(true)


# ---------------------------------------------------------------------------
# Modern theme
# ---------------------------------------------------------------------------

func _build_theme() -> Theme:
	var theme: Theme = Theme.new()

	# -- Panel (glassmorphism) --
	var panel_style: StyleBoxFlat = StyleBoxFlat.new()
	panel_style.bg_color = COL_PANEL_BG
	panel_style.set_corner_radius_all(20)
	panel_style.set_border_width_all(2)
	panel_style.border_color = COL_PANEL_BORDER
	panel_style.set_content_margin_all(22.0)
	panel_style.shadow_color = Color(0.0, 0.0, 0.0, 0.40)
	panel_style.shadow_size = 18
	theme.set_stylebox("panel", "PanelContainer", panel_style)

	# -- Primary button (play, replay, confirm) -- capsule peinte degrade
	# cyan->violet avec liseres neon, dans le style du mockup approuve
	# (design_previews/ui_mockup_menu.png), au lieu d'un simple aplat
	# de couleur code en dur.
	var btn_primary: StyleBoxTexture = StyleBoxTexture.new()
	btn_primary.texture = BTN_PRIMARY_TEXTURE
	btn_primary.texture_margin_left = 60.0
	btn_primary.texture_margin_right = 60.0
	btn_primary.texture_margin_top = 14.0
	btn_primary.texture_margin_bottom = 14.0
	btn_primary.set_content_margin_all(14.0)
	btn_primary.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	btn_primary.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	btn_primary.modulate_color = Color(1.0, 1.0, 1.0, 1.0)

	var btn_primary_hover: StyleBoxTexture = btn_primary.duplicate()
	btn_primary_hover.modulate_color = Color(1.18, 1.18, 1.18, 1.0)

	var btn_primary_pressed: StyleBoxTexture = btn_primary.duplicate()
	btn_primary_pressed.modulate_color = Color(0.82, 0.82, 0.82, 1.0)

	# -- Secondary button -- meme capsule mais variante sombre/vitree --
	var btn_sec: StyleBoxTexture = StyleBoxTexture.new()
	btn_sec.texture = BTN_SECONDARY_TEXTURE
	btn_sec.texture_margin_left = 60.0
	btn_sec.texture_margin_right = 60.0
	btn_sec.texture_margin_top = 14.0
	btn_sec.texture_margin_bottom = 14.0
	btn_sec.set_content_margin_all(12.0)
	btn_sec.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	btn_sec.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	btn_sec.modulate_color = Color(1.0, 1.0, 1.0, 1.0)

	var btn_sec_hover: StyleBoxTexture = btn_sec.duplicate()
	btn_sec_hover.modulate_color = Color(1.35, 1.35, 1.4, 1.0)

	var btn_sec_pressed: StyleBoxTexture = btn_sec.duplicate()
	btn_sec_pressed.modulate_color = Color(0.75, 0.75, 0.8, 1.0)

	var btn_disabled: StyleBoxTexture = btn_sec.duplicate()
	btn_disabled.modulate_color = Color(0.5, 0.5, 0.5, 0.6)

	# Apply primary style to Button
	theme.set_stylebox("normal", "Button", btn_primary)
	theme.set_stylebox("hover", "Button", btn_primary_hover)
	theme.set_stylebox("pressed", "Button", btn_primary_pressed)
	theme.set_stylebox("disabled", "Button", btn_disabled)
	theme.set_stylebox("focus", "Button", btn_primary_hover)
	theme.set_color("font_color", "Button", COL_TEXT)
	theme.set_color("font_hover_color", "Button", Color.WHITE)
	theme.set_color("font_disabled_color", "Button", Color("#505a6a"))

	# Apply secondary style to CheckButton / OptionButton
	theme.set_stylebox("normal", "CheckButton", btn_sec)
	theme.set_stylebox("hover", "CheckButton", btn_sec_hover)
	theme.set_stylebox("pressed", "CheckButton", btn_sec_pressed)
	theme.set_stylebox("disabled", "CheckButton", btn_disabled)
	theme.set_stylebox("focus", "CheckButton", btn_sec_hover)
	theme.set_color("font_color", "CheckButton", COL_TEXT)
	theme.set_color("font_hover_color", "CheckButton", Color.WHITE)
	theme.set_color("font_disabled_color", "CheckButton", Color("#505a6a"))

	theme.set_stylebox("normal", "OptionButton", btn_sec)
	theme.set_stylebox("hover", "OptionButton", btn_sec_hover)
	theme.set_stylebox("pressed", "OptionButton", btn_sec_pressed)
	theme.set_stylebox("disabled", "OptionButton", btn_disabled)
	theme.set_stylebox("focus", "OptionButton", btn_sec_hover)
	theme.set_color("font_color", "OptionButton", COL_TEXT)
	theme.set_color("font_hover_color", "OptionButton", Color.WHITE)
	theme.set_color("font_disabled_color", "OptionButton", Color("#505a6a"))

	# -- LineEdit -- reste un champ plat classique (pas une capsule bouton) --
	var le_style: StyleBoxFlat = StyleBoxFlat.new()
	le_style.bg_color = Color(0.03, 0.06, 0.12, 0.95)
	le_style.set_corner_radius_all(12)
	le_style.set_border_width_all(2)
	le_style.border_color = COL_PANEL_BORDER
	le_style.set_content_margin_all(10.0)
	var le_style_focus: StyleBoxFlat = le_style.duplicate()
	le_style_focus.border_color = Color(0.30, 0.60, 0.95, 0.70)
	theme.set_stylebox("normal", "LineEdit", le_style)
	theme.set_stylebox("focus", "LineEdit", le_style_focus)
	theme.set_color("font_color", "LineEdit", COL_TEXT)
	theme.set_color("font_placeholder_color", "LineEdit", Color("#5a6a80"))

	# -- Scrollbar --
	var sb: StyleBoxFlat = StyleBoxFlat.new()
	sb.bg_color = COL_ACCENT_DIM; sb.set_corner_radius_all(6)
	theme.set_stylebox("grabber", "VScrollBar", sb)
	theme.set_stylebox("grabber_highlight", "VScrollBar", sb)

	return theme


# ---------------------------------------------------------------------------
# Menu root
# ---------------------------------------------------------------------------

func _create_menu() -> void:
	var layer: CanvasLayer = CanvasLayer.new()
	layer.name = "Menu"
	add_child(layer)

	_menu_root = Control.new()
	_menu_root.name = "MenuRoot"
	_menu_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	# FIX boutons pause/parametres : un Control plein ecran avec le filtre de
	# souris par defaut (STOP) avale tous les taps/cles destines au HUD. En
	# IGNORE, il ne bloque plus rien et les ecrans (enfants) restent cliquables.
	_menu_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_root.theme = _build_theme()
	layer.add_child(_menu_root)

	# Fond spatial peint (nebuleuses cyan/violette + planetes), commun a
	# tous les ecrans de menu (start, pause, boutique, classement, etc.)
	# pour que la navigation reste visuellement cohérente et ne retombe
	# jamais sur un simple aplat noir.
	var menu_bg: TextureRect = TextureRect.new()
	menu_bg.name = "MenuBackground"
	menu_bg.texture = MENU_BG_TEXTURE
	menu_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	menu_bg.stretch_mode = TextureRect.STRETCH_SCALE
	menu_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_bg.modulate = Color(0.62, 0.62, 0.7, 1.0)
	_menu_root.add_child(menu_bg)
	_menu_background = menu_bg

	var shade: ColorRect = ColorRect.new()
	shade.name = "Shade"
	shade.color = COL_SHADE
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_menu_root.add_child(shade)
	_menu_shade = shade

	_screen_language = _build_language_screen()
	_screen_start = _build_start_screen()
	_screen_pseudo = _build_pseudo_screen()
	_screen_game_over = _build_game_over_screen()
	_screen_leaderboard = _build_leaderboard_screen()
	_screen_settings = _build_settings_screen()
	_screen_shop = _build_shop_screen()
	_screen_credits = _build_credits_screen()
	_screen_pause = _build_pause_screen()
	_screen_tutorial = _build_tutorial_screen()
	_screen_consent = _build_consent_screen()

	_menu_root.add_child(_screen_language)
	_menu_root.add_child(_screen_start)
	_menu_root.add_child(_screen_pseudo)
	_menu_root.add_child(_screen_game_over)
	_menu_root.add_child(_screen_leaderboard)
	_menu_root.add_child(_screen_settings)
	_menu_root.add_child(_screen_shop)
	_menu_root.add_child(_screen_credits)
	_menu_root.add_child(_screen_pause)
	_menu_root.add_child(_screen_tutorial)
	_menu_root.add_child(_screen_consent)

	_ads_debug_label = Label.new()
	_ads_debug_label.name = "AdsDebug"
	_ads_debug_label.text = "Ads: ..."
	_ads_debug_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ads_debug_label.anchor_left = 0.5; _ads_debug_label.anchor_right = 0.5
	_ads_debug_label.anchor_top = 1.0; _ads_debug_label.anchor_bottom = 1.0
	_ads_debug_label.offset_left = -480.0; _ads_debug_label.offset_right = 480.0
	_ads_debug_label.offset_top = -46.0; _ads_debug_label.offset_bottom = -10.0
	_ads_debug_label.add_theme_font_size_override("font_size", 14)
	_ads_debug_label.add_theme_color_override("font_color", COL_GOLD)
	_ads_debug_label.add_theme_constant_override("outline_size", 4)
	_ads_debug_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.9))
	_ads_debug_label.visible = ADS_DEBUG_VISIBLE
	layer.add_child(_ads_debug_label)

	_show_screen(null)


func _show_screen(screen: Control) -> void:
	if _screen_language != null: _screen_language.visible = screen == _screen_language
	if _screen_start != null: _screen_start.visible = screen == _screen_start
	if _screen_pseudo != null: _screen_pseudo.visible = screen == _screen_pseudo
	if _screen_game_over != null: _screen_game_over.visible = screen == _screen_game_over
	if _screen_leaderboard != null: _screen_leaderboard.visible = screen == _screen_leaderboard
	if _screen_settings != null: _screen_settings.visible = screen == _screen_settings
	if _screen_shop != null: _screen_shop.visible = screen == _screen_shop
	if _screen_credits != null: _screen_credits.visible = screen == _screen_credits
	if _screen_pause != null: _screen_pause.visible = screen == _screen_pause
	if _screen_tutorial != null: _screen_tutorial.visible = screen == _screen_tutorial
	if _screen_consent != null: _screen_consent.visible = screen == _screen_consent
	if _menu_shade != null: _menu_shade.visible = screen != null
	# CRITIQUE : le fond peint du menu est opaque (JPEG). S'il reste visible
	# en permanence (comme avant ce correctif), il masque TOUT le jeu
	# (HUD, vaisseau, ennemis) des que le menu se ferme (_show_screen(null)
	# au lancement d'une partie) puisqu'il est ajoute sur un CanvasLayer
	# au-dessus de la scene de jeu. Il ne doit donc etre visible que quand
	# un ecran de menu l'est reellement.
	if _menu_background != null: _menu_background.visible = screen != null
	if screen != null:
		_dismiss_interstitial_prompt()


# ---------------------------------------------------------------------------
# UI helpers (modern style)
# ---------------------------------------------------------------------------

func _make_panel_container(width: float, height: float) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	panel.anchor_left = 0.5; panel.anchor_top = 0.5; panel.anchor_right = 0.5; panel.anchor_bottom = 0.5
	panel.offset_left = -width * 0.5; panel.offset_top = -height * 0.5
	panel.offset_right = width * 0.5; panel.offset_bottom = height * 0.5
	return panel


func _make_title(text: String) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color("#f4fbff"))
	return label


func _make_body_label() -> Label:
	var label: Label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", COL_TEXT_DIM)
	return label


func _make_section_label(text: String) -> Label:
	var label: Label = Label.new()
	label.text = text.to_upper()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", COL_SECTION)
	return label


func _make_action_button(text: String) -> Button:
	var button: Button = Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(260.0, 50.0)
	button.add_theme_font_size_override("font_size", 18)
	return button


func _make_secondary_button(text: String) -> Button:
	var button: Button = _make_action_button(text)
	# Meme capsule peinte neon (variante sombre) que les CheckButton/OptionButton
	# du theme -- garde une apparence unifiee avec le mockup approuve au lieu
	# d'un aplat de couleur code en dur qui ne correspondait plus au style
	# des autres boutons de l'ecran.
	var sb: StyleBoxTexture = StyleBoxTexture.new()
	sb.texture = BTN_SECONDARY_TEXTURE
	sb.texture_margin_left = 60.0
	sb.texture_margin_right = 60.0
	sb.texture_margin_top = 14.0
	sb.texture_margin_bottom = 14.0
	sb.set_content_margin_all(10.0)
	sb.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	sb.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	button.add_theme_stylebox_override("normal", sb)
	var sb_h: StyleBoxTexture = sb.duplicate(); sb_h.modulate_color = Color(1.35, 1.35, 1.4, 1.0)
	button.add_theme_stylebox_override("hover", sb_h)
	var sb_p: StyleBoxTexture = sb.duplicate(); sb_p.modulate_color = Color(0.75, 0.75, 0.8, 1.0)
	button.add_theme_stylebox_override("pressed", sb_p)
	return button


func _apply_chip_button_style(button: Button) -> void:
	"""Meme capsule neon que les autres boutons, mais avec des marges de
	9-slice reduites pour les petites 'puces' de filtre (ex. Tous / Commun /
	Rare) -- avec les marges pleines (60px) ces boutons etroits ecrasaient
	le degrade et deformaient les coins arrondis en une forme pincee."""
	var sb: StyleBoxTexture = StyleBoxTexture.new()
	sb.texture = BTN_SECONDARY_TEXTURE
	sb.texture_margin_left = 24.0
	sb.texture_margin_right = 24.0
	sb.texture_margin_top = 14.0
	sb.texture_margin_bottom = 14.0
	sb.set_content_margin_all(6.0)
	sb.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	sb.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	button.add_theme_stylebox_override("normal", sb)
	var sb_h: StyleBoxTexture = sb.duplicate(); sb_h.modulate_color = Color(1.35, 1.35, 1.4, 1.0)
	button.add_theme_stylebox_override("hover", sb_h)
	var sb_p: StyleBoxTexture = sb.duplicate(); sb_p.texture = BTN_PRIMARY_TEXTURE
	button.add_theme_stylebox_override("pressed", sb_p)


func _make_volume_row(parent: Control, label_text: String, value: float, callback: Callable) -> Array:
	"""Volume row: label + percentage + HSlider. Returns [slider, label]."""
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.custom_minimum_size = Vector2(0.0, 36.0)
	parent.add_child(row)
	var text_label: Label = Label.new()
	text_label.text = label_text
	text_label.add_theme_font_size_override("font_size", 14)
	text_label.add_theme_color_override("font_color", COL_TEXT)
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.custom_minimum_size = Vector2(130.0, 0.0)
	row.add_child(text_label)
	var pct_label: Label = Label.new()
	pct_label.text = str(int(round(value * 100.0))) + "%"
	pct_label.add_theme_font_size_override("font_size", 13)
	pct_label.add_theme_color_override("font_color", COL_GOLD)
	pct_label.custom_minimum_size = Vector2(42.0, 0.0)
	pct_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(pct_label)
	var slider: HSlider = HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.05
	slider.value = value
	slider.custom_minimum_size = Vector2(120.0, 26.0)
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(callback)
	row.add_child(slider)
	return [slider, pct_label]


# ---------------------------------------------------------------------------
# Language screen (shown once on first launch)
# ---------------------------------------------------------------------------

func _build_language_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "LanguageScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(400.0, 300.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 20)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("lang_title")))

	var subtitle: Label = _make_body_label()
	subtitle.text = Settings.loc("lang_subtitle")
	box.add_child(subtitle)

	_language_option = OptionButton.new()
	_language_option.add_item("Francais", 0)
	_language_option.add_item("English", 1)
	_language_option.custom_minimum_size = Vector2(240.0, 44.0)
	box.add_child(_language_option)

	var confirm_button: Button = _make_action_button(Settings.loc("lang_confirm"))
	confirm_button.pressed.connect(_on_language_chosen)
	box.add_child(confirm_button)

	return screen


func _on_language_chosen() -> void:
	var idx: int = _language_option.get_item_id(_language_option.get_selected())
	Settings.language = "fr" if idx == 0 else "en"
	Settings.save()
	Audio.play_sfx("button")
	# Refresh all visible text after language change
	_refresh_screen_texts()
	if Leaderboard.has_pseudo():
		_show_start()
	else:
		_open_pseudo_screen()


func _refresh_screen_texts() -> void:
	# Language screen title
	var lang_title_label: Label = _screen_language.get_node_or_null("PanelContainer/VBoxContainer/Title") as Label
	if lang_title_label == null:
		# Find by looking at children
		var panel: PanelContainer = _screen_language.get_child(0) as PanelContainer
		if panel != null:
			var vbox: VBoxContainer = panel.get_child(0) as VBoxContainer
			if vbox != null and vbox.get_child_count() > 0:
				lang_title_label = vbox.get_child(0) as Label
	if lang_title_label != null:
		lang_title_label.text = Settings.loc("lang_title")


# ---------------------------------------------------------------------------
# Start screen
# ---------------------------------------------------------------------------

func _build_start_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "StartScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(400.0, 420.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	# Logo peint "ASTRO RECOLTE" (image) a la place du simple Label texte.
	var logo_center: CenterContainer = CenterContainer.new()
	var logo: TextureRect = TextureRect.new()
	logo.texture = TITLE_LOGO_TEXTURE
	logo.custom_minimum_size = Vector2(320.0, 176.0)
	logo.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo_center.add_child(logo)
	box.add_child(logo_center)

	_start_body = _make_body_label()
	box.add_child(_start_body)

	_daily_reward_label = Label.new()
	_daily_reward_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_daily_reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_daily_reward_label.add_theme_font_size_override("font_size", 14)
	_daily_reward_label.add_theme_color_override("font_color", COL_GOLD)
	_daily_reward_label.visible = false
	box.add_child(_daily_reward_label)

	_play_button = _make_action_button(Settings.loc("start_play"))
	_play_button.pressed.connect(_start_game)
	box.add_child(_play_button)

	var shop_button: Button = _make_secondary_button(Settings.loc("start_shop"))
	shop_button.pressed.connect(_open_shop_screen)
	box.add_child(shop_button)

	var leaderboard_button: Button = _make_secondary_button(Settings.loc("start_leaderboard"))
	leaderboard_button.pressed.connect(_open_leaderboard.bind(screen))
	box.add_child(leaderboard_button)

	var settings_row: HBoxContainer = HBoxContainer.new()
	settings_row.alignment = BoxContainer.ALIGNMENT_CENTER
	settings_row.add_theme_constant_override("separation", 10)
	box.add_child(settings_row)

	var settings_button: Button = _make_secondary_button(Settings.loc("start_settings"))
	settings_button.add_theme_font_size_override("font_size", 14)
	settings_button.custom_minimum_size = Vector2(160.0, 40.0)
	settings_button.pressed.connect(_open_settings_screen)
	settings_row.add_child(settings_button)

	var credits_button: Button = _make_secondary_button(Settings.loc("start_credits"))
	credits_button.add_theme_font_size_override("font_size", 14)
	credits_button.custom_minimum_size = Vector2(160.0, 40.0)
	credits_button.pressed.connect(_open_credits_screen)
	settings_row.add_child(credits_button)

	var change_pseudo_button: Button = _make_secondary_button(Settings.loc("start_change_pseudo"))
	change_pseudo_button.add_theme_font_size_override("font_size", 13)
	change_pseudo_button.custom_minimum_size = Vector2(260.0, 36.0)
	change_pseudo_button.pressed.connect(_open_pseudo_screen)
	box.add_child(change_pseudo_button)

	# --- Update banner (hidden until check completes) ---
	_update_banner = PanelContainer.new()
	_update_banner.name = "UpdateBanner"
	var banner_sb: StyleBoxFlat = StyleBoxFlat.new()
	banner_sb.bg_color = Color(0.08, 0.28, 0.18, 0.92)
	banner_sb.set_corner_radius_all(12)
	banner_sb.set_border_width_all(2)
	banner_sb.border_color = Color(0.18, 0.78, 0.42, 0.6)
	banner_sb.set_content_margin_all(12.0)
	_update_banner.add_theme_stylebox_override("panel", banner_sb)
	_update_banner.custom_minimum_size = Vector2(360.0, 0.0)
	_update_banner.visible = false
	var banner_vbox: VBoxContainer = VBoxContainer.new()
	banner_vbox.add_theme_constant_override("separation", 4)
	_update_banner.add_child(banner_vbox)
	_update_banner_label = Label.new()
	_update_banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_update_banner_label.add_theme_font_size_override("font_size", 13)
	_update_banner_label.add_theme_color_override("font_color", Color("#8effc8"))
	_update_banner_label.text = "..."
	banner_vbox.add_child(_update_banner_label)
	var banner_btn: Button = Button.new()
	banner_btn.text = Settings.loc("update_download")
	banner_btn.custom_minimum_size = Vector2(200.0, 34.0)
	banner_btn.add_theme_font_size_override("font_size", 13)
	banner_btn.pressed.connect(_open_update_download)
	banner_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	banner_vbox.add_child(banner_btn)
	_update_banner.visible = false
	box.add_child(_update_banner)

	return screen


func _open_update_download() -> void:
	if UpdateChecker.download_url != "":
		OS.shell_open(UpdateChecker.download_url)


# ---------------------------------------------------------------------------
# Update dialog (fullscreen overlay)
# ---------------------------------------------------------------------------

func _build_update_dialog() -> PanelContainer:
	var dialog: PanelContainer = PanelContainer.new()
	dialog.name = "UpdateDialog"
	dialog.set_anchors_preset(Control.PRESET_FULL_RECT)
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.7)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	dialog.add_child(bg)
	var inner_panel: PanelContainer = _make_panel_container(460.0, 360.0)
	dialog.add_child(inner_panel)
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 14)
	inner_panel.add_child(vbox)
	vbox.add_child(_make_title(Settings.loc("update_title")))
	var body: Label = _make_body_label()
	body.text = Settings.loc("update_body") % UpdateChecker.latest_version
	vbox.add_child(body)
	if UpdateChecker.changelog != "":
		var cl_label: Label = _make_body_label()
		cl_label.text = Settings.loc("update_changelog")
		cl_label.add_theme_font_size_override("font_size", 13)
		cl_label.add_theme_color_override("font_color", COL_SECTION)
		vbox.add_child(cl_label)
		var cl_body: Label = _make_body_label()
		cl_body.text = UpdateChecker.changelog
		cl_body.add_theme_font_size_override("font_size", 12)
		cl_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		vbox.add_child(cl_body)
	var dl_button: Button = _make_action_button(Settings.loc("update_download"))
	dl_button.pressed.connect(_open_update_download)
	vbox.add_child(dl_button)
	var later_button: Button = _make_secondary_button(Settings.loc("update_later"))
	later_button.pressed.connect(_close_update_dialog)
	vbox.add_child(later_button)
	return dialog


func _close_update_dialog() -> void:
	if _update_dialog != null and _update_dialog.get_parent() != null:
		_update_dialog.get_parent().remove_child(_update_dialog)
		_update_dialog.queue_free()
		_update_dialog = null
	_update_dialog_visible = false


func _show_update_dialog() -> void:
	if _update_dialog_visible:
		return
	_update_dialog_visible = true
	_update_dialog = _build_update_dialog()
	_menu_root.add_child(_update_dialog)


# ---------------------------------------------------------------------------
# Pseudo screen
# ---------------------------------------------------------------------------

func _build_pseudo_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "PseudoScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(400.0, 300.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("pseudo_title")))

	var hint: Label = _make_body_label()
	hint.text = Settings.loc("pseudo_hint")
	box.add_child(hint)

	# Input + random button row
	var input_row: HBoxContainer = HBoxContainer.new()
	input_row.alignment = BoxContainer.ALIGNMENT_CENTER
	input_row.add_theme_constant_override("separation", 8)
	box.add_child(input_row)

	_pseudo_input = LineEdit.new()
	_pseudo_input.placeholder_text = Settings.loc("pseudo_placeholder")
	_pseudo_input.max_length = 16
	_pseudo_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_pseudo_input.custom_minimum_size = Vector2(200.0, 40.0)
	_pseudo_input.text_submitted.connect(func(_new_text: String) -> void: _confirm_pseudo())
	input_row.add_child(_pseudo_input)

	var random_button: Button = _make_secondary_button(Settings.loc("pseudo_random"))
	random_button.custom_minimum_size = Vector2(120.0, 40.0)
	random_button.add_theme_font_size_override("font_size", 14)
	random_button.pressed.connect(_randomize_pseudo)
	input_row.add_child(random_button)

	_pseudo_feedback = _make_body_label()
	_pseudo_feedback.add_theme_color_override("font_color", Color("#ff9c7b"))
	box.add_child(_pseudo_feedback)

	_pseudo_confirm_button = _make_action_button(Settings.loc("pseudo_confirm"))
	_pseudo_confirm_button.pressed.connect(_confirm_pseudo)
	box.add_child(_pseudo_confirm_button)

	return screen


# ---------------------------------------------------------------------------
# Consent screen
# ---------------------------------------------------------------------------

func _build_consent_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "ConsentScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(460.0, 340.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("consent_title")))

	var body: Label = _make_body_label()
	body.text = Settings.loc("consent_body")
	box.add_child(body)

	_consent_accept_button = _make_action_button(Settings.loc("consent_accept"))
	_consent_accept_button.pressed.connect(_on_consent_accepted)
	box.add_child(_consent_accept_button)

	_consent_decline_button = _make_secondary_button(Settings.loc("consent_decline"))
	_consent_decline_button.pressed.connect(_on_consent_declined)
	box.add_child(_consent_decline_button)

	return screen


# ---------------------------------------------------------------------------
# Game over screen
# ---------------------------------------------------------------------------

func _build_game_over_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "GameOverScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(420.0, 420.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("gameover_title")))

	_game_over_body = _make_body_label()
	box.add_child(_game_over_body)

	_game_over_status = _make_body_label()
	box.add_child(_game_over_status)

	_rewarded_button = Button.new()
	_rewarded_button.text = Settings.loc("gameover_rewarded") % 0
	_rewarded_button.custom_minimum_size = Vector2(320.0, 54.0)
	_rewarded_button.add_theme_font_size_override("font_size", 17)
	_rewarded_button.add_theme_color_override("font_color", Color("#1a1000"))
	var reward_sb: StyleBoxFlat = StyleBoxFlat.new()
	reward_sb.bg_color = COL_GOLD; reward_sb.corner_radius_top_left = 14; reward_sb.corner_radius_top_right = 14
	reward_sb.corner_radius_bottom_left = 14; reward_sb.corner_radius_bottom_right = 14
	_rewarded_button.add_theme_stylebox_override("normal", reward_sb)
	var reward_sb_h: StyleBoxFlat = reward_sb.duplicate(); reward_sb_h.bg_color = Color("#ffc926")
	_rewarded_button.add_theme_stylebox_override("hover", reward_sb_h)
	var reward_sb_p: StyleBoxFlat = reward_sb.duplicate(); reward_sb_p.bg_color = Color("#eeb700")
	_rewarded_button.add_theme_stylebox_override("pressed", reward_sb_p)
	var reward_sb_d: StyleBoxFlat = reward_sb.duplicate(); reward_sb_d.bg_color = Color("#5a5230")
	_rewarded_button.add_theme_stylebox_override("disabled", reward_sb_d)
	_rewarded_button.pressed.connect(_on_rewarded_video_pressed)
	_rewarded_button.visible = false
	box.add_child(_rewarded_button)

	_replay_button = _make_action_button(Settings.loc("gameover_replay"))
	_replay_button.pressed.connect(_start_game)
	box.add_child(_replay_button)

	var leaderboard_button: Button = _make_secondary_button(Settings.loc("gameover_leaderboard"))
	leaderboard_button.pressed.connect(_open_leaderboard.bind(screen))
	box.add_child(leaderboard_button)

	_ads_status_label = Label.new()
	_ads_status_label.text = "SDK: ..."
	_ads_status_label.add_theme_font_size_override("font_size", 11)
	_ads_status_label.add_theme_color_override("font_color", COL_TEXT_DIM)
	_ads_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ads_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_ads_status_label.visible = ADS_DEBUG_VISIBLE
	box.add_child(_ads_status_label)

	return screen


# ---------------------------------------------------------------------------
# Leaderboard screen
# ---------------------------------------------------------------------------

func _build_leaderboard_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "LeaderboardScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(480.0, 440.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("lb_title")))

	_leaderboard_status = _make_body_label()
	box.add_child(_leaderboard_status)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(440.0, 260.0)
	box.add_child(scroll)

	_leaderboard_list = RichTextLabel.new()
	_leaderboard_list.bbcode_enabled = true
	_leaderboard_list.fit_content = true
	_leaderboard_list.scroll_active = false
	_leaderboard_list.custom_minimum_size = Vector2(430.0, 0.0)
	_leaderboard_list.add_theme_font_size_override("normal_font_size", 14)
	_leaderboard_list.add_theme_color_override("default_color", COL_TEXT)
	scroll.add_child(_leaderboard_list)

	var back_button: Button = _make_secondary_button(Settings.loc("lb_back"))
	back_button.pressed.connect(func() -> void: _show_screen(_return_screen))
	box.add_child(back_button)

	return screen


# ---------------------------------------------------------------------------
# Settings screen (FULLSCREEN overlay)
# ---------------------------------------------------------------------------

func _build_settings_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "SettingsScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	# Fullscreen dark background
	var bg: ColorRect = ColorRect.new()
	bg.color = COL_PANEL_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.add_child(bg)

	# AI nebula background (subtle depth, keeps text readable) - meme
	# image que le reste des ecrans de menu pour rester coherent.
	var nebula: TextureRect = TextureRect.new()
	nebula.texture = MENU_BG_TEXTURE
	nebula.set_anchors_preset(Control.PRESET_FULL_RECT)
	nebula.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	nebula.modulate = Color(1.0, 1.0, 1.0, 0.28)
	nebula.mouse_filter = Control.MOUSE_FILTER_IGNORE
	screen.add_child(nebula)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.offset_left = 40.0; scroll.offset_right = -40.0
	scroll.offset_top = 20.0; scroll.offset_bottom = -20.0
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	screen.add_child(scroll)

	var box: VBoxContainer = VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 8)
	scroll.add_child(box)

	# Close button row
	var close_row: HBoxContainer = HBoxContainer.new()
	close_row.alignment = BoxContainer.ALIGNMENT_END
	close_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(close_row)

	var close_button: Button = _make_secondary_button("X")
	close_button.custom_minimum_size = Vector2(44.0, 44.0)
	close_button.add_theme_font_size_override("font_size", 20)
	close_button.pressed.connect(_close_settings)
	close_row.add_child(close_button)

	box.add_child(_make_title(Settings.loc("settings_title")))

	# Language
	box.add_child(_make_section_label(Settings.loc("settings_language")))
	_language_option = OptionButton.new()
	_language_option.add_item("Francais", 0)
	_language_option.add_item("English", 1)
	_language_option.custom_minimum_size = Vector2(280.0, 42.0)
	_language_option.item_selected.connect(_on_language_setting_changed)
	box.add_child(_language_option)

	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_difficulty")))

	_difficulty_option = OptionButton.new()
	_difficulty_option.add_item(Settings.loc("diff_easy"), Settings.Difficulty.EASY)
	_difficulty_option.add_item(Settings.loc("diff_normal"), Settings.Difficulty.NORMAL)
	_difficulty_option.add_item(Settings.loc("diff_hard"), Settings.Difficulty.HARD)
	_difficulty_option.custom_minimum_size = Vector2(280.0, 42.0)
	_difficulty_option.item_selected.connect(_on_difficulty_selected)
	box.add_child(_difficulty_option)

	_touch_toggle = CheckButton.new()
	_touch_toggle.text = Settings.loc("settings_touch")
	_touch_toggle.toggled.connect(_on_touch_toggle_changed)
	box.add_child(_touch_toggle)

	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_audio")))

	_sfx_toggle = CheckButton.new()
	_sfx_toggle.text = Settings.loc("settings_sfx")
	_sfx_toggle.toggled.connect(_on_sfx_toggle_changed)
	box.add_child(_sfx_toggle)

	_music_toggle = CheckButton.new()
	_music_toggle.text = Settings.loc("settings_music")
	_music_toggle.toggled.connect(_on_music_toggle_changed)
	box.add_child(_music_toggle)

	var music_vol_row: Array = _make_volume_row(box, Settings.loc("settings_vol_music"), Settings.music_volume, _on_music_volume_changed)
	_music_volume_slider = music_vol_row[0]; _music_volume_label = music_vol_row[1]
	var sfx_vol_row: Array = _make_volume_row(box, Settings.loc("settings_vol_sfx"), Settings.sfx_volume, _on_sfx_volume_changed)
	_sfx_volume_slider = sfx_vol_row[0]; _sfx_volume_label = sfx_vol_row[1]
	var cine_vol_row: Array = _make_volume_row(box, Settings.loc("settings_vol_cine"), Settings.cine_volume, _on_cine_volume_changed)
	_cine_volume_slider = cine_vol_row[0]; _cine_volume_label = cine_vol_row[1]

	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_accessibility")))

	_reduce_motion_toggle = CheckButton.new()
	_reduce_motion_toggle.text = Settings.loc("settings_reduce_motion")
	_reduce_motion_toggle.toggled.connect(_on_reduce_motion_toggle_changed)
	box.add_child(_reduce_motion_toggle)

	_high_contrast_toggle = CheckButton.new()
	_high_contrast_toggle.text = Settings.loc("settings_high_contrast")
	_high_contrast_toggle.toggled.connect(_on_high_contrast_toggle_changed)
	box.add_child(_high_contrast_toggle)

	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_progression")))

	_settings_progress_label = _make_body_label()
	box.add_child(_settings_progress_label)

	var shop_link_button: Button = _make_secondary_button(Settings.loc("settings_open_shop"))
	shop_link_button.add_theme_font_size_override("font_size", 14)
	shop_link_button.custom_minimum_size = Vector2(280.0, 40.0)
	shop_link_button.pressed.connect(_open_shop_screen)
	box.add_child(shop_link_button)

	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_ads")))

	_ads_consent_toggle = CheckButton.new()
	_ads_consent_toggle.text = Settings.loc("settings_ads_toggle")
	_ads_consent_toggle.button_pressed = AdsManager.has_consent()
	_ads_consent_toggle.toggled.connect(_on_ads_consent_toggled)
	box.add_child(_ads_consent_toggle)

	# --- Stats section ---
	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_stats")))
	var stats_lines: Array[String] = [
		Settings.loc("stat_games_played") % Shop.games_played,
		Settings.loc("stat_best_score") % Shop.best_score,
		Settings.loc("stat_best_combo") % Shop.best_combo,
		Settings.loc("stat_crystals_earned") % Shop.total_crystals_earned,
		Settings.loc("stat_bosses_defeated") % Shop.bosses_defeated,
		Settings.loc("stat_sets_owned") % [Shop.owned_count(), Shop.total_count()],
	]
	for line in stats_lines:
		var stat_label: Label = _make_body_label()
		stat_label.text = line
		stat_label.add_theme_font_size_override("font_size", 13)
		box.add_child(stat_label)

	# --- Achievements section ---
	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("achievements_title")))
	var achievements: Array[Dictionary] = Settings.check_achievements()
	for ach in achievements:
		var ach_row: HBoxContainer = HBoxContainer.new()
		ach_row.add_theme_constant_override("separation", 10)
		ach_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var icon_label: Label = Label.new()
		icon_label.text = "\u2713" if ach.unlocked else "\u25CB"
		icon_label.add_theme_font_size_override("font_size", 18)
		icon_label.add_theme_color_override("font_color", Color("#8effc8") if ach.unlocked else Color("#505a6a"))
		icon_label.custom_minimum_size = Vector2(24.0, 0.0)
		ach_row.add_child(icon_label)
		var ach_text: VBoxContainer = VBoxContainer.new()
		ach_text.add_theme_constant_override("separation", 1)
		var ach_title: Label = Label.new()
		ach_title.text = ach.title
		ach_title.add_theme_font_size_override("font_size", 14)
		ach_title.add_theme_color_override("font_color", COL_TEXT if ach.unlocked else Color("#5a6a80"))
		ach_text.add_child(ach_title)
		var ach_desc: Label = Label.new()
		ach_desc.text = ach.desc
		ach_desc.add_theme_font_size_override("font_size", 11)
		ach_desc.add_theme_color_override("font_color", COL_TEXT_DIM if ach.unlocked else Color("#3a4458"))
		ach_text.add_child(ach_desc)
		ach_row.add_child(ach_text)
		box.add_child(ach_row)

	box.add_child(HSeparator.new())
	box.add_child(_make_section_label(Settings.loc("settings_misc")))

	_reset_score_button = _make_secondary_button(Settings.loc("settings_reset_score"))
	_reset_score_button.add_theme_font_size_override("font_size", 13)
	_reset_score_button.custom_minimum_size = Vector2(280.0, 38.0)
	_reset_score_button.pressed.connect(_reset_local_high_score)
	box.add_child(_reset_score_button)

	var tutorial_button: Button = _make_secondary_button(Settings.loc("settings_replay_tutorial"))
	tutorial_button.add_theme_font_size_override("font_size", 13)
	tutorial_button.custom_minimum_size = Vector2(280.0, 38.0)
	tutorial_button.pressed.connect(_replay_tutorial)
	box.add_child(tutorial_button)

	var credits_link_button: Button = _make_secondary_button(Settings.loc("settings_credits"))
	credits_link_button.add_theme_font_size_override("font_size", 13)
	credits_link_button.custom_minimum_size = Vector2(280.0, 38.0)
	credits_link_button.pressed.connect(_open_credits_screen)
	box.add_child(credits_link_button)

	# --- Update check section ---
	var update_button: Button = _make_secondary_button(Settings.loc("update_check"))
	update_button.add_theme_font_size_override("font_size", 13)
	update_button.custom_minimum_size = Vector2(280.0, 38.0)
	update_button.pressed.connect(_on_update_check_pressed)
	box.add_child(update_button)

	var back_settings_button: Button = _make_action_button(Settings.loc("settings_back"))
	back_settings_button.pressed.connect(_close_settings)
	box.add_child(back_settings_button)

	return screen


func _on_update_check_pressed() -> void:
	UpdateChecker.check_for_update()
	# Rebuild settings screen after a brief delay
	await get_tree().create_timer(1.5).timeout
	if UpdateChecker.update_available:
		_show_update_dialog()
		AdsManager.notify_update_if_new()


# ---------------------------------------------------------------------------
# Shop
# ---------------------------------------------------------------------------

const SHOP_PAGE_SIZE: int = 6
const SHOP_RARITY_FILTERS_KEYS: Array[String] = ["shop_filter_all", "shop_filter_common", "shop_filter_rare", "shop_filter_epic", "shop_filter_legendary"]

var _shop_page: int = 0
var _preview_active: bool = false
var _shop_rarity_filter: String = "Tous"
var _shop_sort_desc: bool = false
var _shop_grid: GridContainer
var _shop_page_label: Label
var _shop_currency_label: Label
var _shop_progress_label: Label
var _shop_filter_buttons: Array[Button] = []


func _build_shop_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "ShopScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(620.0, 560.0)
	screen.add_child(panel)

	var root_box: VBoxContainer = VBoxContainer.new()
	root_box.add_theme_constant_override("separation", 10)
	panel.add_child(root_box)

	var header_row: HBoxContainer = HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 14)
	root_box.add_child(header_row)

	var title: Label = _make_title(Settings.loc("shop_title"))
	title.custom_minimum_size = Vector2(200.0, 0.0)
	header_row.add_child(title)

	var header_spacer: Control = Control.new()
	header_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(header_spacer)

	_shop_currency_label = Label.new()
	_shop_currency_label.add_theme_font_size_override("font_size", 20)
	_shop_currency_label.add_theme_color_override("font_color", COL_GOLD)
	header_row.add_child(_shop_currency_label)

	_shop_progress_label = _make_body_label()
	_shop_progress_label.add_theme_font_size_override("font_size", 13)
	root_box.add_child(_shop_progress_label)

	var filter_row: HBoxContainer = HBoxContainer.new()
	filter_row.alignment = BoxContainer.ALIGNMENT_CENTER
	filter_row.add_theme_constant_override("separation", 6)
	root_box.add_child(filter_row)

	_shop_filter_buttons.clear()
	for key in SHOP_RARITY_FILTERS_KEYS:
		var fbtn: Button = Button.new()
		fbtn.text = Settings.loc(key)
		fbtn.toggle_mode = true
		fbtn.custom_minimum_size = Vector2(88.0, 34.0)
		fbtn.add_theme_font_size_override("font_size", 12)
		_apply_chip_button_style(fbtn)
		fbtn.pressed.connect(_on_shop_filter_selected.bind(Settings.loc(key)))
		filter_row.add_child(fbtn)
		_shop_filter_buttons.append(fbtn)

	var sort_button: Button = _make_secondary_button(Settings.loc("shop_sort_asc"))
	sort_button.name = "SortButton"
	sort_button.add_theme_font_size_override("font_size", 13)
	sort_button.custom_minimum_size = Vector2(240.0, 36.0)
	sort_button.pressed.connect(_on_shop_sort_toggle.bind(sort_button))
	root_box.add_child(sort_button)

	var grid_scroll: ScrollContainer = ScrollContainer.new()
	grid_scroll.custom_minimum_size = Vector2(0.0, 340.0)
	grid_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root_box.add_child(grid_scroll)

	_shop_grid = GridContainer.new()
	_shop_grid.columns = 2
	_shop_grid.add_theme_constant_override("h_separation", 10)
	_shop_grid.add_theme_constant_override("v_separation", 10)
	grid_scroll.add_child(_shop_grid)

	var page_row: HBoxContainer = HBoxContainer.new()
	page_row.alignment = BoxContainer.ALIGNMENT_CENTER
	page_row.add_theme_constant_override("separation", 16)
	root_box.add_child(page_row)

	var prev_button: Button = _make_secondary_button(Settings.loc("shop_prev"))
	prev_button.add_theme_font_size_override("font_size", 13)
	prev_button.custom_minimum_size = Vector2(130.0, 36.0)
	prev_button.pressed.connect(_on_shop_page_delta.bind(-1))
	page_row.add_child(prev_button)

	_shop_page_label = _make_body_label()
	_shop_page_label.custom_minimum_size = Vector2(100.0, 0.0)
	page_row.add_child(_shop_page_label)

	var next_button: Button = _make_secondary_button(Settings.loc("shop_next"))
	next_button.add_theme_font_size_override("font_size", 13)
	next_button.custom_minimum_size = Vector2(130.0, 36.0)
	next_button.pressed.connect(_on_shop_page_delta.bind(1))
	page_row.add_child(next_button)

	var back_button: Button = _make_secondary_button(Settings.loc("shop_back"))
	back_button.pressed.connect(_close_shop_screen)
	root_box.add_child(back_button)

	return screen


func _build_tutorial_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "TutorialScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(440.0, 460.0)
	screen.add_child(panel)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 10)
	scroll.add_child(box)

	box.add_child(_make_title(Settings.loc("tutorial_title")))

	var steps: Array[String] = [
		Settings.loc("tutorial_step1"),
		Settings.loc("tutorial_step2"),
		Settings.loc("tutorial_step3"),
		Settings.loc("tutorial_step4"),
		Settings.loc("tutorial_step5"),
		Settings.loc("tutorial_step6"),
	]
	for i in range(steps.size()):
		var line: Label = _make_body_label()
		line.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		line.text = "%d. %s" % [i + 1, steps[i]]
		box.add_child(line)

	var start_button: Button = _make_action_button(Settings.loc("tutorial_got_it"))
	start_button.pressed.connect(_close_tutorial)
	box.add_child(start_button)

	return screen


func _maybe_show_tutorial() -> void:
	if Settings.has_seen_tutorial:
		return
	_show_screen(_screen_tutorial)


func _replay_tutorial() -> void:
	_show_screen(_screen_tutorial)


func _close_tutorial() -> void:
	Settings.has_seen_tutorial = true
	Settings.save()
	Audio.play_sfx("button")
	_show_start()


func _build_pause_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "PauseScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(380.0, 360.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("pause_title")))

	_pause_status_label = _make_body_label()
	box.add_child(_pause_status_label)

	var resume_button: Button = _make_action_button(Settings.loc("pause_resume"))
	resume_button.pressed.connect(_toggle_pause)
	box.add_child(resume_button)

	var settings_from_pause_button: Button = _make_secondary_button(Settings.loc("pause_settings"))
	settings_from_pause_button.pressed.connect(_open_settings_screen.bind(true))
	box.add_child(settings_from_pause_button)

	var quit_button: Button = _make_secondary_button(Settings.loc("pause_quit"))
	quit_button.pressed.connect(_quit_run_to_menu)
	box.add_child(quit_button)

	return screen


func _toggle_pause() -> void:
	if not _game_running:
		return
	_paused = not _paused
	_spawn_timer.paused = _paused
	_enemy_spawn_timer.paused = _paused
	Audio.play_sfx("pause")
	if _paused:
		_pause_status_label.text = Settings.loc("pause_status") % [_score, int(_elapsed)]
		_show_screen(_screen_pause)
	else:
		_show_screen(null)


func _quit_run_to_menu() -> void:
	_paused = false
	_show_game_over()


func _open_shop_screen() -> void:
	_shop_page = 0
	_preview_active = false
	_show_screen(_screen_shop)
	_refresh_shop_grid()


func _close_shop_screen() -> void:
	if _preview_active:
		_preview_active = false
		_apply_equipped_cosmetics()
	_show_start()


func _on_shop_try_pressed(id: String) -> void:
	var item: Dictionary = Shop.item_by_id(id)
	if item.is_empty():
		return
	_preview_active = true
	var hull_color: Color = Shop.hull_info(int(item.hull)).color
	var silhouette: String = Shop.hull_silhouette(int(item.hull))
	var tinted_color: Color = _hull_tint_for(silhouette, hull_color)
	if _player_sprite != null:
		_player_sprite.texture = _hull_texture_for(silhouette)
		_player_sprite.modulate = tinted_color
		_player_base_tint = tinted_color
	if _player_trail != null:
		_player_trail.color = Shop.trail_info(int(item.trail)).color
		_configure_trail_style(_player_trail, String(Shop.trail_info(int(item.trail)).get("style", "sparkle")))
	Audio.play_sfx("button")


func _open_credits_screen() -> void:
	_show_screen(_screen_credits)


func _shop_filtered_sorted_catalog() -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	# Map translated filter label back to French label for Shop catalog comparison
	var filter_labels: Array[String] = ["Tous", "Commun", "Rare", "Epique", "Legendaire"]
	var fr_filter: String = _shop_rarity_filter
	for i in range(filter_labels.size()):
		if Settings.loc(SHOP_RARITY_FILTERS_KEYS[i]) == _shop_rarity_filter:
			fr_filter = filter_labels[i]
			break
	for item in Shop.catalog():
		if fr_filter == "Tous" or String(item.rarity.label) == fr_filter:
			items.append(item)
	items.sort_custom(func(a, b):
		if _shop_sort_desc:
			return int(a.price) > int(b.price)
		return int(a.price) < int(b.price)
	)
	return items


func _refresh_shop_grid() -> void:
	for i in range(_shop_filter_buttons.size()):
		_shop_filter_buttons[i].button_pressed = _shop_filter_buttons[i].text == _shop_rarity_filter

	_shop_currency_label.text = Settings.loc("crystals_format") % Shop.currency
	_shop_progress_label.text = Settings.loc("shop_progress") % [
		Shop.owned_count(), Shop.total_count(), Shop.item_by_id(Shop.equipped_set).get("name", "?"),
	]

	var items: Array[Dictionary] = _shop_filtered_sorted_catalog()
	var total_pages: int = max(1, ceili(float(items.size()) / float(SHOP_PAGE_SIZE)))
	_shop_page = clampi(_shop_page, 0, total_pages - 1)
	_shop_page_label.text = Settings.loc("shop_page") % [_shop_page + 1, total_pages]

	for child in _shop_grid.get_children():
		child.queue_free()

	var start_index: int = _shop_page * SHOP_PAGE_SIZE
	var end_index: int = min(start_index + SHOP_PAGE_SIZE, items.size())
	for i in range(start_index, end_index):
		_shop_grid.add_child(_make_shop_item_card(items[i]))


func _rarity_visual(label: String) -> Dictionary:
	# Match against translated or original labels
	if label == "Rare" or label == Settings.loc("shop_filter_rare"):
		return {"border": Color("#4d9dff"), "glow": Color(0.30, 0.61, 1.0, 0.20), "width": 2}
	elif label == "Epique" or label == Settings.loc("shop_filter_epic"):
		return {"border": Color("#b06bff"), "glow": Color(0.69, 0.42, 1.0, 0.24), "width": 2}
	elif label == "Legendaire" or label == Settings.loc("shop_filter_legendary"):
		return {"border": COL_GOLD, "glow": Color(1.0, 0.80, 0.30, 0.3), "width": 3}
	else:
		return {"border": Color("#5a6478"), "glow": Color(0.35, 0.4, 0.5, 0.12), "width": 1}


func _make_shop_item_card(item: Dictionary) -> Control:
	var id: String = String(item.id)
	var rarity_label: String = String(item.rarity.label)
	var visual: Dictionary = _rarity_visual(rarity_label)
	var hull: Dictionary = Shop.hull_info(int(item.hull))
	var trail: Dictionary = Shop.trail_info(int(item.trail))
	var badge: Dictionary = Shop.badge_info(int(item.badge))

	var card: PanelContainer = PanelContainer.new()
	card.custom_minimum_size = Vector2(252.0, 296.0)
	var card_style: StyleBoxFlat = StyleBoxFlat.new()
	card_style.bg_color = Color(0.035, 0.055, 0.105, 0.96)
	card_style.set_corner_radius_all(16)
	card_style.set_border_width_all(int(visual.width))
	card_style.border_color = visual.border
	card_style.set_content_margin_all(12.0)
	card_style.shadow_color = visual.glow
	card_style.shadow_size = 12 if rarity_label == "Legendaire" else 5
	card.add_theme_stylebox_override("panel", card_style)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	card.add_child(vbox)

	var stage: PanelContainer = PanelContainer.new()
	stage.custom_minimum_size = Vector2(0.0, 96.0)
	var stage_style: StyleBoxFlat = StyleBoxFlat.new()
	stage_style.bg_color = visual.glow
	stage_style.set_corner_radius_all(12)
	stage.add_theme_stylebox_override("panel", stage_style)
	vbox.add_child(stage)

	var stage_center: CenterContainer = CenterContainer.new()
	stage.add_child(stage_center)

	var preview_silhouette: String = Shop.hull_silhouette(int(item.hull))
	var ship_preview: TextureRect = TextureRect.new()
	ship_preview.texture = _hull_texture_for(preview_silhouette)
	ship_preview.custom_minimum_size = Vector2(74.0, 74.0)
	ship_preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	ship_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ship_preview.modulate = _hull_tint_for(preview_silhouette, hull.color)
	stage_center.add_child(ship_preview)

	if rarity_label == "Legendaire":
		var ribbon: Label = Label.new()
		ribbon.text = "\u2605"
		ribbon.add_theme_font_size_override("font_size", 20)
		ribbon.add_theme_color_override("font_color", COL_GOLD)
		ribbon.anchor_left = 1.0; ribbon.anchor_right = 1.0
		ribbon.offset_left = -28.0; ribbon.offset_right = -2.0; ribbon.offset_top = 2.0
		stage.add_child(ribbon)

	var hull_name_label: Label = Label.new()
	hull_name_label.text = "%s %s" % [
		String(Shop.SILHOUETTE_LABELS.get(Shop.hull_silhouette(int(item.hull)), "")), String(hull.name),
	]
	hull_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hull_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hull_name_label.add_theme_font_size_override("font_size", 13)
	hull_name_label.add_theme_color_override("font_color", COL_TEXT)
	vbox.add_child(hull_name_label)

	var accessories_row: HBoxContainer = HBoxContainer.new()
	accessories_row.alignment = BoxContainer.ALIGNMENT_CENTER
	accessories_row.add_theme_constant_override("separation", 16)
	vbox.add_child(accessories_row)

	var trail_icon: Texture2D = TRAIL_ICON_TEXTURES.get(String(trail.get("style", "sparkle")), TRAIL_ICON_TEXTURES["sparkle"])
	var badge_icon: Texture2D = BADGE_ICON_TEXTURES.get(String(badge.get("icon", "comete")), BADGE_ICON_TEXTURES["comete"])
	accessories_row.add_child(_make_accessory_chip(trail_icon, trail.color, String(trail.name)))
	# Les badges sont maintenant des illustrations peintes en couleurs
	# fixes (pas des silhouettes blanches) -- ne pas les teinter, sinon
	# leurs propres couleurs (bleu comete, orange meteore, etc.) seraient
	# ecrasees par la couleur de rarete du badge.
	accessories_row.add_child(_make_accessory_chip(badge_icon, badge.color, String(badge.name), false))

	var rarity_row: Label = Label.new()
	rarity_row.text = rarity_label.to_upper()
	rarity_row.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rarity_row.add_theme_font_size_override("font_size", 11)
	rarity_row.add_theme_color_override("font_color", visual.border)
	vbox.add_child(rarity_row)

	var action_button: Button = Button.new()
	action_button.custom_minimum_size = Vector2(0.0, 36.0)
	action_button.add_theme_font_size_override("font_size", 13)

	if Shop.is_owned(id):
		if Shop.equipped_set == id:
			action_button.text = Settings.loc("shop_equipped")
			action_button.disabled = true
		else:
			action_button.text = Settings.loc("shop_equip")
			action_button.pressed.connect(_on_shop_equip_pressed.bind(id))
	else:
		action_button.text = Settings.loc("crystals_format") % int(item.price)
		action_button.disabled = not Shop.can_afford(id)
		action_button.pressed.connect(_on_shop_buy_pressed.bind(id))

	vbox.add_child(action_button)

	var try_button: Button = Button.new()
	try_button.text = Settings.loc("shop_try")
	try_button.custom_minimum_size = Vector2(0.0, 24.0)
	try_button.add_theme_font_size_override("font_size", 10)
	try_button.pressed.connect(_on_shop_try_pressed.bind(id))
	vbox.add_child(try_button)

	return card


func _make_accessory_chip(texture: Texture2D, color: Color, label_text: String, tint: bool = true) -> Control:
	var col: VBoxContainer = VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 2)
	var icon_center: CenterContainer = CenterContainer.new()
	var icon: TextureRect = TextureRect.new()
	icon.texture = texture; icon.modulate = color if tint else Color.WHITE
	icon.custom_minimum_size = Vector2(24.0, 24.0)
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_center.add_child(icon)
	col.add_child(icon_center)
	var label: Label = Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", COL_TEXT_DIM)
	label.custom_minimum_size = Vector2(78.0, 0.0)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(label)
	return col


func _on_shop_filter_selected(label: String) -> void:
	_shop_rarity_filter = label
	_shop_page = 0
	_refresh_shop_grid()


func _on_shop_sort_toggle(button: Button) -> void:
	_shop_sort_desc = not _shop_sort_desc
	button.text = Settings.loc("shop_sort_desc") if _shop_sort_desc else Settings.loc("shop_sort_asc")
	_refresh_shop_grid()


func _on_shop_page_delta(delta: int) -> void:
	_shop_page += delta
	_refresh_shop_grid()


func _on_shop_buy_pressed(id: String) -> void:
	if Shop.purchase(id):
		Audio.play_sfx("purchase")
		_refresh_shop_grid()


func _on_shop_equip_pressed(id: String) -> void:
	if Shop.equip(id):
		_preview_active = false
		_apply_equipped_cosmetics()
		Audio.play_sfx("purchase")
		_refresh_shop_grid()


# ---------------------------------------------------------------------------
# Credits
# ---------------------------------------------------------------------------

func _build_credits_screen() -> Control:
	var screen: Control = Control.new()
	screen.name = "CreditsScreen"
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel: PanelContainer = _make_panel_container(400.0, 380.0)
	screen.add_child(panel)

	var box: VBoxContainer = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)

	box.add_child(_make_title(Settings.loc("credits_title")))

	var ship_icon: TextureRect = TextureRect.new()
	ship_icon.texture = PLAYER_TEXTURE
	ship_icon.custom_minimum_size = Vector2(64.0, 64.0)
	ship_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ship_icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	box.add_child(ship_icon)

	var studio_label: Label = Label.new()
	studio_label.text = Settings.loc("credits_studio")
	studio_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	studio_label.add_theme_font_size_override("font_size", 24)
	studio_label.add_theme_color_override("font_color", COL_GOLD)
	box.add_child(studio_label)

	var role_label: Label = _make_body_label()
	role_label.text = Settings.loc("credits_role")
	box.add_child(role_label)

	var thanks_label: Label = _make_body_label()
	thanks_label.text = Settings.loc("credits_thanks")
	box.add_child(thanks_label)

	var engine_label: Label = _make_body_label()
	engine_label.add_theme_font_size_override("font_size", 12)
	engine_label.text = Settings.loc("credits_engine")
	box.add_child(engine_label)

	var back_button: Button = _make_secondary_button(Settings.loc("credits_back"))
	back_button.pressed.connect(_show_start)
	box.add_child(back_button)

	return screen


# ---------------------------------------------------------------------------
# Settings logic
# ---------------------------------------------------------------------------

func _refresh_update_banner() -> void:
	if _update_banner == null:
		return
	if UpdateChecker.update_available and UpdateChecker.check_done:
		_update_banner_label.text = Settings.loc("update_body") % UpdateChecker.latest_version
		_update_banner.visible = true
		AdsManager.notify_update_if_new()
	elif UpdateChecker.check_done and not UpdateChecker.update_available and UpdateChecker.latest_version != "":
		_update_banner.visible = false
	else:
		# Still loading or error — re-check if needed
		if UpdateChecker.should_check():
			UpdateChecker.check_for_update()
		_update_banner.visible = false


func _open_settings_screen(from_pause: bool = false) -> void:
	_settings_return_to_pause = from_pause
	# Sync language dropdown
	if _language_option != null:
		_language_option.set_pressed_no_signal(false)
		_language_option.select(0 if Settings.language != "en" else 1)
	_difficulty_option.select(_difficulty_option.get_item_index(Settings.difficulty))
	_touch_toggle.button_pressed = Settings.touch_controls_enabled
	_sfx_toggle.button_pressed = Settings.sfx_enabled
	_music_toggle.button_pressed = Settings.music_enabled
	if _music_volume_slider != null:
		_music_volume_slider.set_value_no_signal(Settings.music_volume)
		_music_volume_label.text = str(int(round(Settings.music_volume * 100.0))) + "%"
	if _sfx_volume_slider != null:
		_sfx_volume_slider.set_value_no_signal(Settings.sfx_volume)
		_sfx_volume_label.text = str(int(round(Settings.sfx_volume * 100.0))) + "%"
	if _cine_volume_slider != null:
		_cine_volume_slider.set_value_no_signal(Settings.cine_volume)
		_cine_volume_label.text = str(int(round(Settings.cine_volume * 100.0))) + "%"
	_reduce_motion_toggle.button_pressed = Settings.reduce_motion
	_high_contrast_toggle.button_pressed = Settings.high_contrast
	if _ads_consent_toggle != null:
		_ads_consent_toggle.set_pressed_no_signal(AdsManager.has_consent())
	_settings_progress_label.text = Settings.loc("settings_progress") % [
		Shop.currency, Shop.owned_count(), Shop.total_count(), Shop.best_combo,
	]
	_show_screen(_screen_settings)


func _close_settings() -> void:
	if _settings_return_to_pause and _game_running:
		_show_screen(_screen_pause)
	else:
		_show_start()


func _on_language_setting_changed(index: int) -> void:
	var new_lang: String = "fr" if index == 0 else "en"
	if new_lang == Settings.language:
		return
	Settings.language = new_lang
	Settings.save()
	Audio.play_sfx("button")
	# Rebuild settings screen with new language
	var old_screen: Control = _screen_settings
	_screen_settings = _build_settings_screen()
	_menu_root.remove_child(old_screen)
	old_screen.queue_free()
	_menu_root.add_child(_screen_settings)
	# Re-sync toggles
	_open_settings_screen(_settings_return_to_pause)


func _on_difficulty_selected(index: int) -> void:
	Settings.difficulty = _difficulty_option.get_item_id(index)
	Settings.save()


func _on_touch_toggle_changed(pressed: bool) -> void:
	Settings.touch_controls_enabled = pressed
	Settings.save()


func _on_sfx_toggle_changed(pressed: bool) -> void:
	Settings.sfx_enabled = pressed
	Settings.save()
	if pressed:
		Audio.play_sfx("button")


func _on_music_toggle_changed(pressed: bool) -> void:
	Settings.music_enabled = pressed
	Settings.save()
	Audio.refresh_music_state()


func _on_music_volume_changed(value: float) -> void:
	Settings.music_volume = clampf(value, 0.0, 1.0)
	if _music_volume_label != null:
		_music_volume_label.text = str(int(round(Settings.music_volume * 100.0))) + "%"
	Settings.save()
	Audio.apply_volumes()


func _on_sfx_volume_changed(value: float) -> void:
	Settings.sfx_volume = clampf(value, 0.0, 1.0)
	if _sfx_volume_label != null:
		_sfx_volume_label.text = str(int(round(Settings.sfx_volume * 100.0))) + "%"
	Settings.save()
	Audio.apply_volumes()
	Audio.play_sfx("button")


func _on_cine_volume_changed(value: float) -> void:
	Settings.cine_volume = clampf(value, 0.0, 1.0)
	if _cine_volume_label != null:
		_cine_volume_label.text = str(int(round(Settings.cine_volume * 100.0))) + "%"
	Settings.save()
	Audio.apply_volumes()


func _on_reduce_motion_toggle_changed(pressed: bool) -> void:
	Settings.reduce_motion = pressed
	Settings.save()


func _on_high_contrast_toggle_changed(pressed: bool) -> void:
	Settings.high_contrast = pressed
	Settings.save()
	_apply_accessibility_visuals()


func _apply_accessibility_visuals() -> void:
	var outline: int = 4 if Settings.high_contrast else 0
	var outline_color: Color = Color(0.0, 0.0, 0.0, 0.9)
	for label in [_hud_score, _hud_lives, _hud_time, _hud_currency]:
		if label == null:
			continue
		label.add_theme_constant_override("outline_size", outline)
		label.add_theme_color_override("font_outline_color", outline_color)
	if _menu_shade != null:
		_menu_shade.color = Color(0.0, 0.0, 0.0, 0.88) if Settings.high_contrast else COL_SHADE


func _reset_local_high_score() -> void:
	_high_score = 0
	_save_high_score()
	_reset_score_button.text = Settings.loc("settings_reset_done")


func _open_pseudo_screen() -> void:
	_pseudo_input.text = Leaderboard.pseudo
	_pseudo_input.placeholder_text = Settings.loc("pseudo_placeholder")
	_pseudo_feedback.text = ""
	_show_screen(_screen_pseudo)
	_pseudo_input.grab_focus()


func _confirm_pseudo() -> void:
	var candidate: String = _pseudo_input.text.strip_edges()
	if not _is_valid_pseudo_format(candidate):
		_pseudo_feedback.text = Settings.loc("pseudo_invalid")
		return
	if candidate == Leaderboard.pseudo:
		_pseudo_feedback.text = ""
		_show_start()
		return
	_pseudo_confirm_button.disabled = true
	_pseudo_feedback.add_theme_color_override("font_color", COL_TEXT_DIM)
	_pseudo_feedback.text = Settings.loc("pseudo_checking")
	_awaiting_pseudo_check = true
	Leaderboard.check_pseudo_available(candidate)


func _is_valid_pseudo_format(candidate: String) -> bool:
	if candidate.length() < 3 or candidate.length() > 16:
		return false
	var regex: RegEx = RegEx.new()
	regex.compile("^[A-Za-z0-9_-]+$")
	return regex.search(candidate) != null


func _randomize_pseudo() -> void:
	var adj: String = PSEUDO_ADJECTIVES[_rng.randi_range(0, PSEUDO_ADJECTIVES.size() - 1)]
	var noun: String = PSEUDO_NOUNS[_rng.randi_range(0, PSEUDO_NOUNS.size() - 1)]
	var num: int = _rng.randi_range(0, 999)
	var candidate: String = adj + noun + str(num)
	# Trim to 16 chars max
	if candidate.length() > 16:
		candidate = candidate.substr(0, 16)
	_pseudo_input.text = candidate
	_pseudo_feedback.text = ""
	Audio.play_sfx("button")


func _on_pseudo_check_result(candidate: String, status: String) -> void:
	if not _awaiting_pseudo_check or candidate != _pseudo_input.text.strip_edges():
		return
	_awaiting_pseudo_check = false
	_pseudo_confirm_button.disabled = false
	match status:
		"available":
			Leaderboard.choose_pseudo(candidate)
			_pseudo_feedback.text = ""
			_show_start()
		"taken":
			_pseudo_feedback.add_theme_color_override("font_color", Color("#ff9c7b"))
			_pseudo_feedback.text = Settings.loc("pseudo_taken")
		_:
			_pseudo_feedback.add_theme_color_override("font_color", Color("#ff9c7b"))
			_pseudo_feedback.text = Settings.loc("pseudo_error")


# ---------------------------------------------------------------------------
# Start / Game Over screens
# ---------------------------------------------------------------------------

func _show_start() -> void:
	if Settings.language == "":
		_show_screen(_screen_language)
		return
	if not Settings.has_seen_tutorial:
		_maybe_show_tutorial()
		return
	_game_running = false
	_spawn_timer.stop()
	_touch_controls.visible = false
	AdsManager.hide_game_banner()

	var text: String = Settings.loc("start_info") % Leaderboard.pseudo
	text += "\n" + Settings.loc("start_difficulty") % Settings.difficulty_label()
	if _high_score > 0:
		text += "\n" + Settings.loc("start_high_score") % _high_score
	_start_body.text = text

	if _daily_reward_amount > 0:
		_daily_reward_label.text = Settings.loc("start_daily_reward") % [
			_daily_reward_amount, Shop.streak_days, "s" if Shop.streak_days > 1 else "",
		]
		_daily_reward_label.visible = true
		Audio.play_sfx("daily_reward")
		_daily_reward_amount = 0
	else:
		_daily_reward_label.visible = false

	_show_screen(_screen_start)
	_play_button.grab_focus()
	_update_hud()
	# Update banner
	_refresh_update_banner()
	# Show update dialog on first check
	if UpdateChecker.update_available and UpdateChecker.check_done and not _update_dialog_visible:
		_show_update_dialog()


func _show_game_over() -> void:
	_game_running = false
	_paused = false
	_spawn_timer.stop()
	_enemy_spawn_timer.stop()
	_touch_controls.visible = false
	Audio.stop_music()
	Audio.play_sfx("game_over")
	AdsManager.hide_game_banner()
	if _elapsed >= AdsManager.GAMEOVER_INTERSTITIAL_MIN_SESSION_S:
		if AdsManager.maybe_show_game_over_interstitial():
			_show_interstitial_prompt()

	var is_new_local_record: bool = _score > _high_score
	if is_new_local_record:
		_high_score = _score
		_save_high_score()

	var run_bonus: int = int(_score / 20.0)
	_run_bonus = run_bonus
	Shop.add_currency(run_bonus)
	Shop.record_run(_score, _run_crystals, _run_boss_kills)
	_reward_claimed = false
	# Hide combo HUD
	if _combo_hud_label != null:
		var combo_parent: Control = _combo_hud_label.get_parent()
		if combo_parent != null: combo_parent.modulate.a = 0.0

	_rewarded_button.visible = true
	if not AdsManager.has_consent():
		if AdsManager.consent_decided():
			_rewarded_button.disabled = true
			_rewarded_button.text = Settings.loc("gameover_reward_disabled")
		else:
			_rewarded_button.disabled = false
			_rewarded_button.text = _rewarded_default_text()
	elif not AdsManager.can_show_rewarded():
		_rewarded_button.disabled = true
		_rewarded_button.text = Settings.loc("gameover_reward_capped") % [AdsManager.rewarded_views_today(), AdsManager.MAX_REWARDED_PER_DAY]
	else:
		_rewarded_button.disabled = false
		_rewarded_button.text = _rewarded_default_text()
	AdsManager.reload_rewarded()

	_refresh_ads_status()

	var record_line: String = Settings.loc("gameover_new_record") if is_new_local_record else (Settings.loc("gameover_record") % _high_score)
	_game_over_body.text = Settings.loc("gameover_score") % [
		_score, int(_elapsed), record_line, run_bonus, Shop.currency,
	]
	_game_over_status.add_theme_color_override("font_color", COL_TEXT_DIM)
	_game_over_status.text = Settings.loc("gameover_submitting")

	_show_screen(_screen_game_over)
	_replay_button.grab_focus()
	Leaderboard.submit_score(_score, _elapsed)


func _refresh_ads_status() -> void:
	var status: String = AdsManager.get_status()
	if _ads_status_label != null:
		_ads_status_label.text = status
	if _ads_debug_label != null:
		_ads_debug_label.text = status


func _on_rewarded_video_pressed() -> void:
	if not AdsManager.has_consent():
		if AdsManager.consent_decided():
			_rewarded_button.disabled = true
			_rewarded_button.text = Settings.loc("gameover_reward_disabled")
			return
		_show_screen(_screen_consent)
		_consent_accept_button.grab_focus()
		return
	_start_rewarded_ad()


func _start_rewarded_ad() -> void:
	if not AdsManager.can_show_rewarded():
		_rewarded_button.disabled = true
		_rewarded_button.text = Settings.loc("gameover_reward_capped") % [AdsManager.rewarded_views_today(), AdsManager.MAX_REWARDED_PER_DAY]
		return
	if AdsManager.show_rewarded():
		_rewarded_button.disabled = true
		_rewarded_button.text = Settings.loc("gameover_rewarded_active")
		await get_tree().create_timer(1.0).timeout
		_check_rewarded_completion()
	else:
		AdsManager.reload_rewarded()
		_rewarded_button.text = Settings.loc("gameover_rewarded_unavailable")
		await get_tree().create_timer(2.0).timeout
		_rewarded_button.disabled = false
		_rewarded_button.text = _rewarded_default_text()


func _rewarded_default_text() -> String:
	return Settings.loc("gameover_rewarded") % _run_bonus


func _on_consent_accepted() -> void:
	AdsManager.set_consent(true)
	_show_screen(_screen_game_over)
	_start_rewarded_ad()


func _on_consent_declined() -> void:
	AdsManager.set_consent(false)
	_show_screen(_screen_game_over)
	_rewarded_button.disabled = true
	_rewarded_button.text = Settings.loc("gameover_reward_disabled")


func _on_ads_consent_toggled(enabled: bool) -> void:
	AdsManager.set_consent(enabled)


func _check_rewarded_completion() -> void:
	_ad_check_start = Time.get_ticks_msec()
	var max_duration: float = 60.0
	var elapsed: float = 0.0
	var desktop: bool = OS.get_name() != "Android"
	_ad_countdown_label.visible = true
	if _ad_continue_button != null:
		_ad_continue_button.visible = desktop
		_ad_continue_button.disabled = true
	while elapsed < max_duration:
		if AdsManager.pop_reward():
			_ad_countdown_label.visible = false
			if _ad_continue_button != null:
				_ad_continue_button.visible = false
			_on_rewarded_complete()
			return
		# Attente minimale de visionnage (15s) : la recompense n'est accordee
		# qu'apres ce delai, meme sans clic de l'utilisateur.
		var remaining: int = int(AdsManager.REWARD_MIN_VIEW_S - elapsed)
		if remaining > 0:
			_ad_countdown_label.text = Settings.loc("ad_waiting") % remaining
		else:
			_ad_countdown_label.text = Settings.loc("ad_return")
			if _ad_continue_button != null:
				_ad_continue_button.disabled = false
		await get_tree().create_timer(1.0).timeout
		elapsed += 1.0
	_ad_countdown_label.visible = false
	if _ad_continue_button != null:
		_ad_continue_button.visible = false
	_rewarded_button.disabled = false
	_rewarded_button.text = _rewarded_default_text()


func _on_rewarded_complete() -> void:
	if _reward_claimed:
		return
	_reward_claimed = true
	var extra_bonus: int = _run_bonus
	Shop.add_currency(extra_bonus)
	Shop.save()
	_game_over_body.text = Settings.loc("gameover_x2_body") % [
		_score, int(_elapsed), _run_bonus, extra_bonus, Shop.currency,
	]
	_game_over_status.add_theme_color_override("font_color", COL_GOLD)
	_game_over_status.text = Settings.loc("gameover_x2_active")
	_rewarded_button.visible = false
	Audio.play_sfx("purchase")


func _on_score_submit_result(status: String, score: int) -> void:
	match status:
		"ok_new", "ok_updated":
			_game_over_status.add_theme_color_override("font_color", Color("#8effc8"))
			_game_over_status.text = Settings.loc("gameover_new_record_online") % score
		"not_beaten":
			_game_over_status.add_theme_color_override("font_color", COL_TEXT_DIM)
			_game_over_status.text = Settings.loc("gameover_score_sent")
		"retrying":
			_game_over_status.add_theme_color_override("font_color", COL_GOLD)
			_game_over_status.text = Settings.loc("lb_retrying")
		_:
			_game_over_status.add_theme_color_override("font_color", Color("#ff9c7b"))
			_game_over_status.text = Settings.loc("gameover_score_error")


func _open_leaderboard(return_to: Control) -> void:
	_return_screen = return_to
	_show_screen(_screen_leaderboard)
	_leaderboard_status.text = Settings.loc("lb_loading")
	_leaderboard_list.text = ""
	Leaderboard.fetch_top()


func _on_leaderboard_ready(entries: Array) -> void:
	if entries.is_empty():
		_leaderboard_status.text = Settings.loc("lb_empty")
		_leaderboard_list.text = ""
		return
	_leaderboard_status.text = Settings.loc("lb_header")
	var text: String = ""
	var rank: int = 1
	for entry in entries:
		text += Settings.loc("lb_entry") % [
			rank, entry["pseudo"], entry["score"], int(entry["elapsed"]), entry["ratio"]
		]
		text += "\n"
		rank += 1
	_leaderboard_list.text = text


# ---------------------------------------------------------------------------
# Keyboard / gamepad
# ---------------------------------------------------------------------------

func _register_controls() -> void:
	_add_key_action("move_left", [KEY_LEFT, KEY_A, KEY_Q])
	_add_key_action("move_right", [KEY_RIGHT, KEY_D])
	_add_key_action("move_up", [KEY_UP, KEY_W, KEY_Z])
	_add_key_action("move_down", [KEY_DOWN, KEY_S])
	_add_key_action("start_game", [KEY_SPACE, KEY_ENTER])


func _add_key_action(action_name: StringName, keys: Array[int]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for keycode in keys:
		var exists: bool = false
		for event in InputMap.action_get_events(action_name):
			if event is InputEventKey and event.keycode == keycode:
				exists = true
				break
		if exists:
			continue
		var event: InputEventKey = InputEventKey.new()
		event.keycode = keycode
		InputMap.action_add_event(action_name, event)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _game_running:
			_toggle_pause()
		elif _screen_shop.visible:
			_close_shop_screen()
		elif _screen_settings.visible:
			_close_settings()
		elif _screen_credits.visible or _screen_leaderboard.visible:
			_show_start()
		else:
			get_tree().quit()
		return
	if _game_running:
		return
	if event.is_action_pressed("start_game") and (_screen_start.visible or _screen_game_over.visible):
		_start_game()


# ---------------------------------------------------------------------------
# Gameplay
# ---------------------------------------------------------------------------

func _start_game() -> void:
	_score = 0; _lives = 3; _elapsed = 0.0; _difficulty = 0.0
	_slow_time_left = 0.0; _combo = 0; _invuln_time = 0.0; _lasers_timer = 0.0
	_shield_time_left = 0.0; _speed_time_left = 0.0
	_run_crystals = 0; _run_boss_kills = 0
	_player_sprite.modulate = Color.WHITE
	_game_running = true; _paused = false
	Audio.set_music_zone(0); Audio.start_music()
	_show_screen(null)
	_clear_falling_objects()
	_clear_group("enemies"); _clear_group("enemy_bullets"); _clear_group("player_bullets")
	if _boss != null and is_instance_valid(_boss):
		_boss.queue_free()
	_boss = null; _boss_sprite = null; _boss_state = ""
	_set_boss_hud_visible(false)
	_zone_index = 0; _zone_elapsed = 0.0; _zone_banner_timer = 0.0
	_zone_banner.modulate.a = 0.0
	_apply_zone(0, false)
	_reset_player_position()
	_update_hud()
	_touch_controls.visible = Settings.touch_controls_enabled
	_touch_controls.reset()
	# Play story cinematic (first launch only — it ends with its own launch + title),
	# otherwise play the quick intro cinematic
	var story_played: bool = false
	if not Settings.story_shown:
		_play_story_cinematic()
		await _cinematic_finished()
		story_played = true
	if not story_played:
		_play_intro_cinematic()
		await _cinematic_finished()
	# Banniere Adsterra pendant la partie (si une zone est configuree).
	AdsManager.show_game_banner()
	_spawn_timer.start(0.7)
	_enemy_spawn_timer.start(_enemy_spawn_interval())


func _cinematic_finished() -> void:
	while _cinematic_active:
		await get_tree().process_frame


func _load_high_score() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		_high_score = file.get_32()
		file.close()


func _save_high_score() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(_high_score)
		file.close()


func _move_player(delta: float) -> void:
	if _cinematic_active:
		return
	var speed_mult: float = SLOW_SPEED_MULT if _slow_time_left > 0.0 else 1.0
	if _speed_time_left > 0.0:
		speed_mult *= SPEED_POWERUP_MULT
	var kb_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var touch_dir: Vector2 = _touch_controls.direction if _touch_controls.visible else Vector2.ZERO
	var direction: Vector2 = kb_dir + touch_dir
	if direction.length() > 1.0:
		direction = direction.normalized()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not _touch_controls.visible:
		var target: Vector2 = get_global_mouse_position()
		_player.position = _player.position.move_toward(target, PLAYER_SPEED * 1.35 * speed_mult * delta)
	else:
		_player.position += direction * PLAYER_SPEED * speed_mult * delta
	var size: Vector2 = get_viewport_rect().size
	_player.position.x = clampf(_player.position.x, PLAYER_MARGIN, size.x - PLAYER_MARGIN)
	_player.position.y = clampf(_player.position.y, TOP_MARGIN, size.y - PLAYER_MARGIN)
	var tint: Color = Color(0.62, 0.72, 1.0) if _slow_time_left > 0.0 else _player_base_tint
	if _speed_time_left > 0.0:
		tint = Color(0.4, 1.0, 0.6) if tint == _player_base_tint else tint
	if _shield_time_left > 0.0:
		var pulse: float = 0.55 + 0.45 * sin(_elapsed * 8.0)
		tint = tint.lerp(Color(0.3, 0.85, 1.0), pulse * 0.4)
	if _invuln_time > 0.0 and int(_invuln_time * 16.0) % 2 == 0:
		tint.a = 0.35
	_player_sprite.modulate = tint
	if _player_shield != null:
		_player_shield.emitting = _shield_time_left > 0.0


func _move_falling_objects(delta: float) -> void:
	var size: Vector2 = get_viewport_rect().size
	for item in get_tree().get_nodes_in_group("falling"):
		if not is_instance_valid(item):
			continue
		item.position.y += float(item.get_meta("speed")) * delta
		item.rotation += float(item.get_meta("spin")) * delta
		if item.position.y > size.y + 90.0:
			item.queue_free()


func _spawn_falling_object() -> void:
	if not _game_running or _cinematic_active:
		return
	var roll: float = _rng.randf()
	var kind: String = "star"
	var meteor_chance: float = clampf(0.22 + _difficulty * 0.045, 0.22, 0.55)
	var malus_chance: float = clampf(0.05 + _difficulty * 0.018, 0.05, 0.18)
	if _lives < 3 and _rng.randf() > 0.97:
		kind = "heart"
	elif roll < POWERUP_CHANCE:
		kind = "powerup_shield" if _rng.randf() < 0.5 else "powerup_speed"
	elif roll < malus_chance:
		kind = "malus_slow" if _rng.randf() < 0.5 else "malus_score"
	elif roll < malus_chance + meteor_chance:
		kind = "meteor"

	var item: Area2D = Area2D.new()
	item.name = kind.capitalize()
	item.collision_layer = 2; item.collision_mask = 1; item.monitoring = true
	item.add_to_group("falling")
	item.set_meta("kind", kind); item.set_meta("taken", false)
	item.set_meta("speed", (_rng.randf_range(150.0, 255.0) + _difficulty * 24.0) * _zone_speed_mult())
	item.set_meta("spin", _rng.randf_range(-3.2, 3.2))

	var sprite: Sprite2D = Sprite2D.new()
	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()

	if kind == "meteor":
		sprite.texture = METEOR_TEXTURE; sprite.scale = Vector2(0.52, 0.52)
		sprite.modulate = _zone_theme(_zone_index).get("meteor_tint", Color.WHITE)
		circle.radius = 28.0
	elif kind == "heart":
		sprite.texture = HEART_TEXTURE; sprite.scale = Vector2(0.42, 0.42)
		circle.radius = 23.0
	elif kind == "malus_slow":
		sprite.texture = METEOR_TEXTURE; sprite.scale = Vector2(0.5, 0.5)
		sprite.modulate = Color(0.66, 0.46, 1.0)
		circle.radius = 27.0
	elif kind == "malus_score":
		sprite.texture = METEOR_TEXTURE; sprite.scale = Vector2(0.46, 0.46)
		sprite.modulate = Color(0.86, 0.92, 0.36)
		circle.radius = 25.0
	elif kind == "powerup_shield":
		sprite.texture = HEART_TEXTURE; sprite.scale = Vector2(0.44, 0.44)
		sprite.modulate = Color(0.3, 0.85, 1.0)
		circle.radius = 24.0
	elif kind == "powerup_speed":
		sprite.texture = STAR_TEXTURE; sprite.scale = Vector2(0.5, 0.5)
		sprite.modulate = Color(0.2, 1.0, 0.5)
		circle.radius = 24.0
	else:
		sprite.texture = STAR_TEXTURE; sprite.scale = Vector2(0.42, 0.42)
		circle.radius = 23.0

	shape.shape = circle
	item.add_child(sprite); item.add_child(shape)
	item.area_entered.connect(_on_falling_area_entered.bind(item))
	var size: Vector2 = get_viewport_rect().size
	item.position = Vector2(_rng.randf_range(42.0, size.x - 42.0), -55.0)
	add_child(item)
	_spawn_timer.wait_time = clampf(0.68 - _difficulty * 0.042, 0.2, 0.68)


func _on_falling_area_entered(area: Area2D, item: Area2D) -> void:
	if area != _player or bool(item.get_meta("taken")):
		return
	# No damage/collection during cinematics
	if _cinematic_active:
		item.set_meta("taken", true); item.queue_free(); return
	item.set_meta("taken", true)
	var kind: String = String(item.get_meta("kind"))
	if kind == "meteor":
		_hurt_player(item.position, Color("#ff7b58"), 0.25, 8.0)
	elif kind == "heart":
		_lives = min(_lives + 1, 3); _score += 5
		_spawn_burst(item.position, Color("#8effc8"))
		_spawn_floating_text(item.position, "+1 life" if Settings.language == "en" else "+1 vie", Color("#8effc8"))
		Audio.play_sfx("heart")
	elif kind == "malus_slow":
		_apply_slow_debuff(2.5)
		if not Settings.reduce_motion: _shake(0.15, 4.0)
		_spawn_burst(item.position, Color("#9b6bff"))
		Audio.play_sfx("hurt")
	elif kind == "malus_score":
		_score = max(_score - 10, 0)
		if not Settings.reduce_motion: _shake(0.2, 6.0)
		_spawn_burst(item.position, Color("#c9d94a"))
		Audio.play_sfx("hurt")
	elif kind == "powerup_shield":
		_shield_time_left = SHIELD_POWERUP_TIME
		_invuln_time = max(_invuln_time, SHIELD_POWERUP_TIME)
		_spawn_burst(item.position, Color("#3dd8ff"))
		_spawn_floating_text(item.position, Settings.loc("powerup_shield"), Color("#3dd8ff"))
		Audio.play_sfx("heart")
	elif kind == "powerup_speed":
		_speed_time_left = SPEED_POWERUP_TIME
		_spawn_burst(item.position, Color("#33ff88"))
		_spawn_floating_text(item.position, Settings.loc("powerup_speed"), Color("#33ff88"))
		Audio.play_sfx("star")
	else:
		_combo += 1; Shop.register_combo(_combo)
		var combo_bonus: int = _combo / 5; var gain: int = 1 + combo_bonus
		_score += 10 + combo_bonus * 2
		Shop.add_currency(gain)
		_run_crystals += gain
		_spawn_burst(item.position, Color("#fff17a"))
		if _combo >= 5 and _combo % 5 == 0:
			_spawn_floating_text(item.position, "Combo x%d !" % _combo, COL_GOLD)
			if not Settings.reduce_motion: _shake(0.15, 3.0 + float(_combo) * 0.08)
			Audio.play_sfx("combo")
		else:
			_spawn_floating_text(item.position, "+%d" % gain, Color("#fff17a"))
			Audio.play_sfx("star")
	item.queue_free()
	_update_hud()


func _apply_slow_debuff(duration: float) -> void:
	_slow_time_left = max(_slow_time_left, duration)


func _spawn_burst(world_position: Vector2, color: Color) -> void:
	var particles: CPUParticles2D = CPUParticles2D.new()
	particles.position = world_position; particles.amount = 24; particles.one_shot = true
	particles.lifetime = 0.45; particles.explosiveness = 0.95; particles.spread = 180.0
	particles.gravity = Vector2(0.0, 70.0)
	particles.initial_velocity_min = 75.0; particles.initial_velocity_max = 170.0
	particles.scale_amount_min = 2.0; particles.scale_amount_max = 4.5
	particles.color = color
	add_child(particles); particles.emitting = true
	await get_tree().create_timer(0.8).timeout
	if is_instance_valid(particles): particles.queue_free()


func _spawn_floating_text(world_position: Vector2, text: String, color: Color) -> void:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 5)
	label.add_theme_color_override("font_outline_color", Color(0.02, 0.02, 0.05, 0.85))
	label.z_index = 60
	label.position = world_position + Vector2(-24.0, -18.0)
	add_child(label)
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 46.0, 0.7).set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "modulate:a", 0.0, 0.7).set_delay(0.15)
	tween.set_parallel(false)
	tween.tween_callback(label.queue_free)


func _shake(time: float, strength: float) -> void:
	_shake_time = max(_shake_time, time)
	_shake_strength = max(_shake_strength, strength)


func _update_camera(delta: float) -> void:
	if _shake_time > 0.0:
		_shake_time -= delta
		var amount: float = _shake_strength * (_shake_time / 0.25)
		_camera.offset = Vector2(_rng.randf_range(-amount, amount), _rng.randf_range(-amount, amount))
	else:
		_camera.offset = Vector2.ZERO; _shake_strength = 0.0


func _update_hud() -> void:
	_hud_score.text = Settings.loc("hud_score") % _score
	_hud_lives.text = Settings.loc("hud_lives") % _lives
	_hud_time.text = Settings.loc("hud_time") % int(_elapsed)
	_hud_currency.text = Settings.loc("currency_format") % Shop.currency
	# Combo HUD
	if _combo_hud_label != null and _combo_hud_bar != null and _combo_hud_bar_bg != null:
		if _combo >= 3:
			var parent: Control = _combo_hud_label.get_parent()
			if parent != null: parent.modulate.a = 1.0
			_combo_hud_label.text = Settings.loc("combo_label") + " x%d" % _combo
			var bar_max_w: float = 248.0
			var fill: float = clampf(float(_combo) / 50.0, 0.0, 1.0)
			_combo_hud_bar.offset_right = 6.0 + bar_max_w * fill
		else:
			var parent2: Control = _combo_hud_label.get_parent()
			if parent2 != null: parent2.modulate.a = 0.0


func _reset_player_position() -> void:
	var size: Vector2 = get_viewport_rect().size
	_player.position = Vector2(size.x * 0.5, size.y - 72.0)
	_player.rotation = 0.0
	_player.scale = Vector2.ONE


func _clear_falling_objects() -> void:
	for item in get_tree().get_nodes_in_group("falling"):
		if is_instance_valid(item): item.queue_free()


func _clear_group(group_name: String) -> void:
	for node in get_tree().get_nodes_in_group(group_name):
		if is_instance_valid(node): node.queue_free()


func _hurt_player(at_position: Vector2, burst_color: Color, shake_time: float, shake_strength: float) -> void:
	if _cinematic_active or _invuln_time > 0.0:
		_spawn_burst(at_position, Color(0.6, 0.75, 1.0, 0.8))
		Audio.play_sfx("shield")
		return
	_lives -= 1; _combo = 0; _invuln_time = PLAYER_INVULN_TIME
	if not Settings.reduce_motion: _shake(shake_time, shake_strength)
	_spawn_burst(at_position, burst_color)
	Audio.play_sfx("hurt")
	_update_hud()
	if _lives <= 0: _show_game_over()


func _flash_hit(sprite: Sprite2D, base_color: Color) -> void:
	if sprite == null or not is_instance_valid(sprite): return
	sprite.modulate = Color(1.8, 1.8, 1.8, 1.0)
	await get_tree().create_timer(0.07).timeout
	if is_instance_valid(sprite): sprite.modulate = base_color


# ---------------------------------------------------------------------------
# Player lasers
# ---------------------------------------------------------------------------

func _update_player_lasers(delta: float) -> void:
	if _cinematic_active:
		return
	_lasers_timer -= delta
	if _lasers_timer <= 0.0:
		_lasers_timer = PLAYER_FIRE_INTERVAL
		_fire_player_laser()
	for bullet in get_tree().get_nodes_in_group("player_bullets"):
		if not is_instance_valid(bullet): continue
		bullet.position.y -= PLAYER_LASER_SPEED * delta
		if bullet.position.y < -40.0: bullet.queue_free()


func _fire_player_laser() -> void:
	if not is_instance_valid(_player): return
	var bullet: Area2D = Area2D.new()
	bullet.name = "PlayerBolt"
	bullet.collision_layer = LAYER_PLAYER_BULLET; bullet.collision_mask = LAYER_ENEMY
	bullet.monitoring = true; bullet.add_to_group("player_bullets")
	bullet.set_meta("spent", false)
	var sprite: Sprite2D = Sprite2D.new()
	sprite.name = "Sprite"; sprite.texture = PLAYER_BOLT_TEXTURE; sprite.scale = Vector2(0.85, 0.85)
	bullet.add_child(sprite)
	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 8.0; shape.shape = circle
	bullet.add_child(shape)
	bullet.position = _player.position + Vector2(0.0, -30.0)
	bullet.area_entered.connect(_on_player_bullet_area_entered.bind(bullet))
	add_child(bullet)
	Audio.play_sfx("laser")


func _on_player_bullet_area_entered(area: Area2D, bullet: Area2D) -> void:
	if not is_instance_valid(bullet) or bool(bullet.get_meta("spent")): return
	if _boss != null and area == _boss and is_instance_valid(_boss):
		bullet.set_meta("spent", true); bullet.queue_free()
		_damage_boss(PLAYER_LASER_DAMAGE)
		return
	if area.is_in_group("enemies") and not bool(area.get_meta("dead", false)):
		bullet.set_meta("spent", true); bullet.queue_free()
		_damage_enemy(area, PLAYER_LASER_DAMAGE)


# ---------------------------------------------------------------------------
# Enemies
# ---------------------------------------------------------------------------

func _maybe_spawn_enemy() -> void:
	if not _game_running or _boss_state != "": return
	if _elapsed < ENEMY_GRACE_TIME: return
	var kind: String = "chasseur"
	var interceptor_chance: float = clampf(0.18 + float(_zone_index) * 0.05, 0.18, 0.42)
	if _rng.randf() < interceptor_chance: kind = "intercepteur"

	var enemy: Area2D = Area2D.new()
	enemy.name = "Chasseur" if kind == "chasseur" else "Intercepteur"
	enemy.collision_layer = LAYER_ENEMY; enemy.collision_mask = LAYER_PLAYER
	enemy.monitoring = true; enemy.add_to_group("enemies")
	var base_color: Color = Color(1.0, 0.55, 0.7) if kind == "chasseur" else Color(0.72, 0.62, 1.05)
	var hp: float = 1.0 if kind == "chasseur" else 2.0
	var reward: int = 15 if kind == "chasseur" else 32
	enemy.set_meta("hp", hp); enemy.set_meta("dead", false); enemy.set_meta("base_color", base_color)
	enemy.set_meta("can_shoot", kind == "intercepteur")
	enemy.set_meta("fire_timer", _rng.randf_range(1.4, 2.4))
	enemy.set_meta("reward", reward)
	enemy.set_meta("weave_offset", _rng.randf_range(0.0, TAU))
	enemy.set_meta("weave_speed", ENEMY_WEAVE_FREQ * _rng.randf_range(0.85, 1.2))
	enemy.set_meta("fall_speed", _rng.randf_range(ENEMY_FALL_SPEED_MIN, ENEMY_FALL_SPEED_MAX) * _zone_speed_mult())

	var sprite: Sprite2D = Sprite2D.new()
	sprite.name = "Sprite"; sprite.texture = ENEMY_TEXTURE
	# 0.2647 = equivalent visuel de l'ancien SVG 112x112 avec scale 0.52 sur
	# la nouvelle texture peinte PNG plus grande nativement.
	sprite.scale = Vector2(0.2647, 0.2647) if kind == "chasseur" else Vector2(0.3157, 0.3157)
	sprite.modulate = base_color
	enemy.add_child(sprite)
	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 24.0 if kind == "chasseur" else 29.0
	shape.shape = circle; enemy.add_child(shape)
	var size: Vector2 = get_viewport_rect().size
	var start_x: float = _rng.randf_range(64.0, size.x - 64.0)
	enemy.set_meta("base_x", start_x)
	enemy.position = Vector2(start_x, -60.0)
	enemy.area_entered.connect(_on_enemy_area_entered.bind(enemy))
	add_child(enemy)


func _move_enemies(delta: float) -> void:
	var size: Vector2 = get_viewport_rect().size
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy): continue
		var weave_offset: float = float(enemy.get_meta("weave_offset"))
		var weave_speed: float = float(enemy.get_meta("weave_speed"))
		var base_x: float = float(enemy.get_meta("base_x"))
		var t: float = weave_offset + _elapsed * weave_speed
		enemy.position.y += float(enemy.get_meta("fall_speed")) * delta
		enemy.position.x = clampf(base_x + sin(t) * ENEMY_WEAVE_AMPLITUDE, PLAYER_MARGIN, size.x - PLAYER_MARGIN)
		if bool(enemy.get_meta("can_shoot", false)):
			var fire_timer: float = float(enemy.get_meta("fire_timer")) - delta
			if fire_timer <= 0.0:
				fire_timer = _rng.randf_range(1.8, 2.8)
				_fire_enemy_bullet(enemy.position, 0.0)
			enemy.set_meta("fire_timer", fire_timer)
		if enemy.position.y > size.y + 90.0: enemy.queue_free()


func _on_enemy_area_entered(area: Area2D, enemy: Area2D) -> void:
	if area != _player or not is_instance_valid(enemy) or bool(enemy.get_meta("dead", false)): return
	enemy.set_meta("dead", true)
	_hurt_player(enemy.position, Color("#ff7b58"), 0.2, 6.0)
	enemy.queue_free()


func _damage_enemy(node: Area2D, dmg: float) -> void:
	if not is_instance_valid(node) or bool(node.get_meta("dead", false)): return
	var hp: float = float(node.get_meta("hp")) - dmg
	if hp <= 0.0:
		node.set_meta("dead", true)
		_score += int(node.get_meta("reward", 15))
		Shop.add_currency(5)
		_run_crystals += 5
		_spawn_burst(node.position, Color("#ff8a5c"))
		_spawn_floating_text(node.position, "+5", COL_GOLD)
		Audio.play_sfx("enemy_kill")
		node.queue_free()
		_update_hud()
	else:
		node.set_meta("hp", hp)
		if node.has_node("Sprite"):
			_flash_hit(node.get_node("Sprite"), Color(node.get_meta("base_color", Color.WHITE)))


func _fire_enemy_bullet(origin: Vector2, x_bias: float) -> void:
	var bullet: Area2D = Area2D.new()
	bullet.name = "EnemyBolt"
	bullet.collision_layer = LAYER_ENEMY_BULLET; bullet.collision_mask = LAYER_PLAYER
	bullet.monitoring = true; bullet.add_to_group("enemy_bullets")
	var sprite: Sprite2D = Sprite2D.new()
	sprite.name = "Sprite"; sprite.texture = ENEMY_BOLT_TEXTURE; sprite.scale = Vector2(0.8, 0.8)
	bullet.add_child(sprite)
	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 8.0; shape.shape = circle; bullet.add_child(shape)
	var target_x: float = _player.position.x if is_instance_valid(_player) else origin.x
	var direction_x: float = clampf((target_x - origin.x) + x_bias, -140.0, 140.0)
	bullet.set_meta("vx", direction_x * 0.6)
	bullet.position = origin + Vector2(0.0, 20.0)
	bullet.area_entered.connect(_on_enemy_bullet_area_entered.bind(bullet))
	add_child(bullet)


func _move_enemy_bullets(delta: float) -> void:
	var size: Vector2 = get_viewport_rect().size
	for bullet in get_tree().get_nodes_in_group("enemy_bullets"):
		if not is_instance_valid(bullet): continue
		bullet.position.y += ENEMY_BULLET_SPEED * delta
		bullet.position.x += float(bullet.get_meta("vx", 0.0)) * delta
		if bullet.position.y > size.y + 60.0: bullet.queue_free()


func _on_enemy_bullet_area_entered(area: Area2D, bullet: Area2D) -> void:
	if area != _player or not is_instance_valid(bullet): return
	bullet.queue_free()
	_hurt_player(bullet.position, Color("#ff8f6b"), 0.15, 4.0)


# ---------------------------------------------------------------------------
# Boss
# ---------------------------------------------------------------------------

func _spawn_boss() -> void:
	var theme: Dictionary = _zone_theme(_zone_index)
	# Play boss warning cinematic first
	_play_boss_warning_cinematic(String(theme.get("boss_name", "Boss")))
	await _cinematic_finished()
	var hp: float = BOSS_BASE_HP + float(_zone_index) * BOSS_HP_PER_ZONE
	_boss = Area2D.new()
	_boss.name = "Boss"
	_boss.collision_layer = LAYER_ENEMY; _boss.collision_mask = LAYER_PLAYER
	_boss.monitoring = true; _boss.set_meta("hp", hp); _boss.set_meta("max_hp", hp)
	var sprite: Sprite2D = Sprite2D.new()
	# 0.288 = equivalent visuel de l'ancien SVG 200x160 avec scale 0.72 sur
	# la nouvelle texture peinte PNG plus grande nativement.
	sprite.name = "Sprite"; sprite.texture = BOSS_TEXTURE; sprite.scale = Vector2(0.288, 0.288)
	_boss.add_child(sprite); _boss_sprite = sprite
	var shape: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 62.0; shape.shape = circle; _boss.add_child(shape)
	var size: Vector2 = get_viewport_rect().size
	_boss.position = Vector2(size.x * 0.5, -100.0)
	_boss.area_entered.connect(_on_boss_area_entered)
	add_child(_boss)
	_boss_state = "entering"; _boss_fire_timer = 1.4; _boss_pattern_step = 0
	_boss_name_label.text = String(theme.get("boss_name", "Boss"))
	_set_boss_hud_visible(true)
	_update_boss_bar()
	_spawn_timer.stop(); _enemy_spawn_timer.stop()
	_clear_group("enemies"); _clear_group("enemy_bullets")


func _update_boss(delta: float) -> void:
	if _boss == null or not is_instance_valid(_boss): return
	var size: Vector2 = get_viewport_rect().size
	if _boss_state == "entering":
		_boss.position.y = min(_boss.position.y + BOSS_ENTRY_SPEED * delta, BOSS_HOVER_Y)
		if _boss.position.y >= BOSS_HOVER_Y: _boss_state = "fighting"
		return
	if _boss_state != "fighting": return
	var t: float = _elapsed * 0.6
	_boss.position.x = clampf(size.x * 0.5 + sin(t) * (size.x * 0.5 - 90.0), 90.0, size.x - 90.0)
	var fire_interval: float = max(BOSS_FIRE_INTERVAL_BASE - float(_zone_index) * 0.12, BOSS_FIRE_INTERVAL_MIN)
	_boss_fire_timer -= delta
	if _boss_fire_timer <= 0.0:
		_boss_fire_timer = fire_interval
		_fire_boss_pattern()


func _fire_boss_pattern() -> void:
	if _boss == null or not is_instance_valid(_boss): return
	_boss_pattern_step += 1
	match _zone_index % 5:
		0: _fire_pattern_spread()
		1: _fire_pattern_rotating()
		2: _fire_pattern_wall()
		3: _fire_pattern_aimed_burst()
		4: _fire_pattern_spiral()
		_: _fire_pattern_spread()


func _fire_pattern_spread() -> void:
	var count: int = clampi(BOSS_BULLET_BASE_COUNT + int(_zone_index / 2), BOSS_BULLET_BASE_COUNT, 6)
	var spread: float = 90.0
	for i in range(count):
		var t: float = float(i) / float(max(count - 1, 1))
		_fire_enemy_bullet(_boss.position, lerpf(-spread, spread, t))


func _fire_pattern_rotating() -> void:
	var count: int = 4
	var rotation_offset: float = fmod(float(_boss_pattern_step) * 35.0, 140.0) - 70.0
	var spread: float = 40.0
	for i in range(count):
		var t: float = float(i) / float(max(count - 1, 1))
		_fire_enemy_bullet(_boss.position, lerpf(-spread, spread, t) + rotation_offset)


func _fire_pattern_wall() -> void:
	var count: int = 7; var spread: float = 130.0
	for i in range(count):
		var t: float = float(i) / float(max(count - 1, 1))
		_fire_enemy_bullet(_boss.position, lerpf(-spread, spread, t))


func _fire_pattern_aimed_burst() -> void:
	for i in range(3):
		_fire_enemy_bullet(_boss.position + Vector2(0.0, float(i) * -10.0), _rng.randf_range(-8.0, 8.0))


func _fire_pattern_spiral() -> void:
	var count: int = 5
	var sweep: float = fmod(float(_boss_pattern_step) * 18.0, 240.0) - 120.0
	var spread: float = 50.0
	for i in range(count):
		var t: float = float(i) / float(max(count - 1, 1))
		_fire_enemy_bullet(_boss.position, lerpf(-spread, spread, t) + sweep * 0.4)


func _damage_boss(dmg: float) -> void:
	if _boss == null or not is_instance_valid(_boss) or _boss_state != "fighting": return
	var hp: float = float(_boss.get_meta("hp")) - dmg
	_boss.set_meta("hp", max(hp, 0.0))
	_update_boss_bar()
	if _boss_sprite != null: _flash_hit(_boss_sprite, Color.WHITE)
	_spawn_burst(_boss.position + Vector2(_rng.randf_range(-24.0, 24.0), _rng.randf_range(-16.0, 16.0)), Color("#ffdf6b"))
	if hp <= 0.0:
		_defeat_boss()
	else:
		Audio.play_sfx("boss_hit")


func _on_boss_area_entered(area: Area2D) -> void:
	if area != _player or _boss == null or not is_instance_valid(_boss): return
	_hurt_player(_boss.position, Color("#ff7b58"), 0.25, 8.0)


func _defeat_boss() -> void:
	if _boss == null: return
	var boss_pos: Vector2 = _boss.position
	var boss_currency: int = 40 + _zone_index * 15
	_score += BOSS_DEFEAT_REWARD_BASE + _zone_index * BOSS_DEFEAT_REWARD_PER_ZONE
	Shop.add_currency(boss_currency)
	_run_boss_kills += 1
	_run_crystals += boss_currency
	# Multiple explosion bursts
	_spawn_burst(boss_pos, Color("#ffd76b"))
	_spawn_burst(boss_pos + Vector2(-40.0, 15.0), Color("#ff8a5c"))
	_spawn_burst(boss_pos + Vector2(40.0, -20.0), Color("#ffffff"))
	_spawn_burst(boss_pos + Vector2(-20.0, -25.0), Color("#ffd76b"))
	_spawn_burst(boss_pos + Vector2(20.0, 20.0), Color("#ff6b6b"))
	var crystals_text: String = "+%d " + ("crystals" if Settings.language == "en" else "cristaux")
	_spawn_floating_text(boss_pos, crystals_text % boss_currency, COL_GOLD)
	Audio.play_sfx("boss_defeat")
	_boss.queue_free(); _boss = null; _boss_sprite = null; _boss_state = ""
	_set_boss_hud_visible(false)
	_clear_group("enemy_bullets")
	_invuln_time = max(_invuln_time, 1.1)
	_zone_index += 1; _apply_zone(_zone_index, true)
	_update_hud()
	# Boss victory cinematic
	_play_boss_defeat_cinematic()
	await _cinematic_finished()
	# Zone transition cinematic
	_play_zone_transition_cinematic(_zone_index)
	await _cinematic_finished()
	# Invite (non-intrusive) a consulter une pub Adsterra tous les N secteurs.
	if AdsManager.maybe_show_interstitial(_zone_index):
		_show_interstitial_prompt()
	_spawn_timer.start(0.7)
	_enemy_spawn_timer.start(_enemy_spawn_interval())


## Affiche une invite cliquable (jamais automatique) proposant une pub
## Adsterra. Se ferme seule apres quelques secondes si ignoree.
func _show_interstitial_prompt() -> void:
	if _interstitial_prompt == null:
		return
	_interstitial_prompt.modulate.a = 0.0
	_interstitial_prompt.visible = true
	var tw: Tween = create_tween()
	tw.tween_property(_interstitial_prompt, "modulate:a", 1.0, 0.25)
	tw.tween_interval(6.0)
	tw.tween_property(_interstitial_prompt, "modulate:a", 0.0, 0.4)
	tw.tween_callback(func(): _interstitial_prompt.visible = false)


func _dismiss_interstitial_prompt() -> void:
	if _interstitial_prompt == null:
		return
	_interstitial_prompt.visible = false


func _on_interstitial_prompt_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		OS.shell_open(AdsManager.AD_SMARTLINK_URL)
		_dismiss_interstitial_prompt()


func _update_boss_bar() -> void:
	if _boss == null or not is_instance_valid(_boss): return
	var hp: float = float(_boss.get_meta("hp"))
	var max_hp: float = float(_boss.get_meta("max_hp"))
	var fraction: float = clampf(hp / max_hp, 0.0, 1.0) if max_hp > 0.0 else 0.0
	_boss_bar_fill.offset_right = _boss_bar_fill.offset_left + 332.0 * fraction


func _set_boss_hud_visible(is_visible: bool) -> void:
	_boss_name_label.visible = is_visible
	_boss_bar_bg.visible = is_visible
	_boss_bar_fill.visible = is_visible


func _animate_boss_victory() -> void:
	if Settings.reduce_motion:
		return
	# Flash white
	if _boss_flash_rect != null:
		_boss_flash_rect.modulate.a = 0.7
		var tw: Tween = create_tween()
		tw.tween_property(_boss_flash_rect, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_OUT)
	# Victory text
	if _boss_victory_label != null:
		_boss_victory_label.text = Settings.loc("boss_victory")
		_boss_victory_label.modulate.a = 0.0
		_boss_victory_label.scale = Vector2(1.5, 1.5)
		_boss_victory_label.visible = true
		var tw2: Tween = create_tween()
		tw2.tween_property(_boss_victory_label, "modulate:a", 1.0, 0.15)
		tw2.parallel().tween_property(_boss_victory_label, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tw2.tween_interval(1.2)
		tw2.tween_property(_boss_victory_label, "modulate:a", 0.0, 0.3)
		tw2.tween_callback(func(): _boss_victory_label.visible = false)
	# Sub text
	if _boss_victory_sub != null:
		_boss_victory_sub.text = Settings.loc("next_sector")
		_boss_victory_sub.modulate.a = 0.0
		_boss_victory_sub.visible = true
		var tw3: Tween = create_tween()
		tw3.tween_interval(0.5)
		tw3.tween_property(_boss_victory_sub, "modulate:a", 1.0, 0.2)
		tw3.tween_interval(0.8)
		tw3.tween_property(_boss_victory_sub, "modulate:a", 0.0, 0.3)
		tw3.tween_callback(func(): _boss_victory_sub.visible = false)


# ---------------------------------------------------------------------------
# Cinematics (smooth, non-jerky transitions)
# ---------------------------------------------------------------------------

# ---------- Helper functions for story cinematics ----------

func _story_particles(color: Color, count: int, spread: float) -> void:
	"""Spawn floating particle dots in the cinematic overlay for ambient atmosphere."""
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5
	var cy: float = size.y * 0.5
	for i in range(count):
		var p: Sprite2D = Sprite2D.new()
		var img: Image = Image.create(4, 4, false, Image.FORMAT_RGBA8)
		img.fill(color)
		p.texture = ImageTexture.create_from_image(img)
		p.position = Vector2(cx + _rng.randf_range(-spread * 8.0, spread * 8.0), cy + _rng.randf_range(-spread * 5.0, spread * 5.0))
		p.modulate.a = 0.0
		p.z_index = 192
		_cine_overlay.add_child(p)
		var ptw: Tween = create_tween()
		ptw.tween_property(p, "modulate:a", _rng.randf_range(0.4, 0.8), 0.5).set_delay(float(i) * 0.1)
		ptw.parallel().tween_property(p, "position:y", p.position.y - _rng.randf_range(10.0, 30.0), 2.0)
		ptw.chain().tween_property(p, "modulate:a", 0.0, 0.5)
		ptw.tween_callback(p.queue_free)


func _story_speed_lines(color: Color, count: int) -> void:
	"""Draw anime-style speed lines radiating from center."""
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5
	var cy: float = size.y * 0.5
	for i in range(count):
		var line: ColorRect = ColorRect.new()
		line.color = color
		var angle: float = _rng.randf_range(0.0, TAU)
		var dist: float = _rng.randf_range(80.0, 200.0)
		line.position = Vector2(cx + cos(angle) * dist, cy + sin(angle) * dist)
		line.size = Vector2(_rng.randf_range(40.0, 120.0), _rng.randf_range(1.0, 3.0))
		line.rotation = angle
		line.modulate.a = 0.0
		line.z_index = 191
		_cine_overlay.add_child(line)
		var ltween: Tween = create_tween()
		ltween.tween_property(line, "modulate:a", _rng.randf_range(0.5, 0.9), 0.15).set_delay(float(i) * 0.02)
		ltween.parallel().tween_property(line, "position", line.position + Vector2(cos(angle) * 200.0, sin(angle) * 200.0), 0.4)
		ltween.chain().tween_property(line, "modulate:a", 0.0, 0.2)
		ltween.tween_callback(line.queue_free)

# ---------- End helper functions ----------

func _cine_bg_show(tex: Texture2D, alpha: float = 0.8) -> void:
	"""Show an AI background in the cinematic overlay, cross-fading from the previous one.
	The background is slightly oversized and slowly drifts (Ken Burns) so the image
	is never static — but the artwork itself is never modified."""
	var bg: TextureRect = TextureRect.new()
	bg.name = "CineBg"
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.texture = tex
	bg.modulate = Color(1.0, 1.0, 1.0, 0.0)
	bg.z_index = 0
	# Oversize + drift so the pan never reveals an edge
	bg.offset_left = -60.0; bg.offset_right = 60.0
	bg.offset_top = -60.0; bg.offset_bottom = 60.0
	bg.pivot_offset = Vector2.ZERO
	_cine_overlay.add_child(bg)
	var tw: Tween = create_tween()
	tw.tween_property(bg, "modulate:a", alpha, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	# Slow Ken Burns drift + subtle zoom (skipped in reduce-motion mode).
	# The tween is created ON the bg node so it dies automatically when the
	# background is freed (no "infinite loop" leaks).
	if not Settings.reduce_motion:
		var drift: Tween = bg.create_tween().set_loops()
		drift.tween_property(bg, "position", Vector2(24.0, 14.0), 9.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		drift.tween_property(bg, "position", Vector2(-24.0, -14.0), 9.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		drift.tween_property(bg, "position", Vector2(0.0, 0.0), 9.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		drift.parallel().tween_property(bg, "scale", Vector2(1.06, 1.06), 13.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		drift.tween_property(bg, "scale", Vector2(1.0, 1.0), 13.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if _cine_bg != null and is_instance_valid(_cine_bg):
		var old: TextureRect = _cine_bg
		var old_tw: Tween = create_tween()
		old_tw.tween_property(old, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)
		old_tw.tween_callback(old.queue_free)
	_cine_bg = bg


func _play_intro_cinematic() -> void:
	"""Anime-style intro: hyperspace speed lines, ship flyby, dramatic title slam."""
	_cinematic_active = true
	_player.visible = false
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5; var cy: float = size.y * 0.5

	# --- Phase 1: Hyperspace speed lines (0.8s) ---
	Audio.play_cine_music("warp")
	Audio.play_sfx("hyperspace")
	_cine_overlay.color = Color(0.0, 0.0, 0.0, 1.0)
	_cine_overlay.modulate.a = 1.0
	_cine_bg_show(CINE_BG_INTRO, 0.75)
	# Spawn speed lines as vertical particles
	for i in range(18):
		var line: ColorRect = ColorRect.new()
		line.color = Color(0.4 + _rng.randf() * 0.3, 0.6 + _rng.randf() * 0.3, 1.0, 0.0)
		line.position = Vector2(_rng.randf_range(0.0, size.x), -_rng.randf_range(20.0, 300.0))
		line.size = Vector2(2.0, _rng.randf_range(80.0, 220.0))
		line.z_index = 190
		_cine_overlay.add_child(line)
		var tw_line: Tween = create_tween()
		tw_line.tween_property(line, "position:y", size.y + 300.0, _rng.randf_range(0.3, 0.7)).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tw_line.parallel().tween_property(line, "modulate:a", 1.0, 0.1)
		tw_line.parallel().tween_property(line, "modulate:a", 0.0, 0.3).set_delay(0.3)
		tw_line.tween_callback(line.queue_free)
	_shake(0.3, 3.0)
	await get_tree().create_timer(0.6).timeout

	# --- Phase 2: Hero ship swoops in from bottom with trail ---
	# The hero is added INSIDE the overlay so it stays visible (the overlay is opaque black).
	# The real _player is never touched, so it can't end up tilted or out of place.
	var hero: Sprite2D = Sprite2D.new()
	hero.texture = _player_sprite.texture
	hero.scale = _player_sprite.scale * 1.25
	hero.modulate = _player_base_tint
	hero.position = Vector2(cx + 100.0, size.y + 60.0)
	hero.z_index = 193
	_cine_overlay.add_child(hero)
	# Engine trail (child of hero so it follows automatically)
	var intro_trail: CPUParticles2D = CPUParticles2D.new()
	intro_trail.amount = 32; intro_trail.lifetime = 0.5; intro_trail.one_shot = false
	intro_trail.explosiveness = 0.7; intro_trail.spread = 15.0; intro_trail.gravity = Vector2(0, 40)
	intro_trail.initial_velocity_min = 60.0; intro_trail.initial_velocity_max = 120.0
	intro_trail.scale_amount_min = 2.5; intro_trail.scale_amount_max = 5.0
	intro_trail.color = Color("#00aaff")
	intro_trail.position = Vector2(0.0, 26.0)
	intro_trail.emitting = true
	hero.add_child(intro_trail)
	# Swoop up with a banking wobble
	var ship_tween: Tween = create_tween()
	ship_tween.set_parallel(true)
	ship_tween.tween_property(hero, "position", Vector2(cx - 20.0, cy - 10.0), 0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	ship_tween.tween_property(hero, "rotation", -0.12, 0.45).set_ease(Tween.EASE_OUT)
	ship_tween.tween_property(hero, "rotation", 0.12, 0.45).set_delay(0.45).set_ease(Tween.EASE_IN_OUT)
	await ship_tween.finished
	await get_tree().create_timer(0.3).timeout

	# --- Phase 3: Title SLAM with screen flash ---
	# White flash
	_boss_flash_rect.modulate.a = 0.8
	var flash_tw: Tween = create_tween()
	flash_tw.tween_property(_boss_flash_rect, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# Title slam — starts huge, slams to normal
	_cine_title_label.text = Settings.loc("cine_welcome")
	_cine_title_label.modulate.a = 1.0
	_cine_title_label.scale = Vector2(3.0, 3.0)
	_cine_title_label.visible = true
	var slam_tw: Tween = create_tween()
	slam_tw.tween_property(_cine_title_label, "scale", Vector2(1.0, 1.0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_shake(0.2, 8.0)
	await slam_tw.finished
	await get_tree().create_timer(0.6).timeout

	# --- Phase 4: Subtitle types in letter by letter ---
	_cine_subtitle_label.text = ""
	_cine_subtitle_label.modulate.a = 1.0
	_cine_subtitle_label.visible = true
	var full_sub: String = Settings.loc("cine_subtitle")
	for ci in range(full_sub.length()):
		if not _cinematic_active: break
		_cine_subtitle_label.text = full_sub.substr(0, ci + 1)
		await get_tree().create_timer(0.04).timeout
	await get_tree().create_timer(0.8).timeout

	# --- Phase 5: Everything blasts away (title zooms up, ship flies off) ---
	var exit_tw: Tween = create_tween()
	exit_tw.set_parallel(true)
	exit_tw.tween_property(_cine_title_label, "scale", Vector2(0.5, 0.5), 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	exit_tw.tween_property(_cine_title_label, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_IN)
	exit_tw.tween_property(_cine_subtitle_label, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
	exit_tw.tween_property(_cine_overlay, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	exit_tw.tween_property(hero, "position", Vector2(cx, -80.0), 0.6).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	exit_tw.tween_property(hero, "scale", hero.scale * 1.4, 0.6).set_ease(Tween.EASE_IN)
	await exit_tw.finished

	# Cleanup
	if is_instance_valid(hero): hero.queue_free()
	if _cine_bg != null and is_instance_valid(_cine_bg): _cine_bg.queue_free()
	_cine_bg = null
	Audio.stop_cine_music()
	Audio.start_music()
	_cine_title_label.visible = false
	_cine_subtitle_label.visible = false
	_player.visible = true
	_cinematic_active = false


func _play_boss_warning_cinematic(boss_name: String) -> void:
	"""Anime-style boss warning: red strobe, glitch text, boss silhouette reveal, lightning."""
	_cinematic_active = true
	_player.visible = false
	_spawn_timer.stop(); _enemy_spawn_timer.stop()
	_clear_group("falling"); _clear_group("enemies"); _clear_group("enemy_bullets")
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5; var cy: float = size.y * 0.5

	# --- Phase 1: Red strobe flash (anime danger sense) ---
	Audio.play_cine_music("tension")
	Audio.play_sfx("alarm")
	_cine_overlay.color = Color(0.6, 0.0, 0.0, 0.0)
	_cine_overlay.modulate.a = 1.0
	for i in range(5):
		_cine_overlay.color.a = 0.3 + (i % 2) * 0.2
		await get_tree().create_timer(0.08).timeout
	_cine_overlay.color.a = 0.0
	await get_tree().create_timer(0.15).timeout
	_cine_bg_show(CINE_BG_SCOURGE, 0.55)
	# Full red wash
	_cine_overlay.color = Color(0.25, 0.0, 0.0, 0.85)
	var red_in: Tween = create_tween()
	red_in.tween_property(_cine_overlay, "modulate:a", 1.0, 0.4)
	await red_in.finished

	# --- Phase 2: WARNING slam — huge scale → slam down ---
	_cine_title_label.text = Settings.loc("cine_boss_warning")
	_cine_title_label.add_theme_color_override("font_color", Color("#ff3333"))
	_cine_title_label.modulate.a = 1.0
	_cine_title_label.scale = Vector2(4.0, 4.0)
	_cine_title_label.visible = true
	_shake(0.25, 10.0)
	var slam_tw: Tween = create_tween()
	slam_tw.tween_property(_cine_title_label, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	await slam_tw.finished
	# Strobe the warning text red/white
	for i in range(4):
		_cine_title_label.add_theme_color_override("font_color", Color("#ffffff"))
		await get_tree().create_timer(0.06).timeout
		_cine_title_label.add_theme_color_override("font_color", Color("#ff3333"))
		await get_tree().create_timer(0.06).timeout
	await get_tree().create_timer(0.3).timeout

	# --- Phase 3: Boss silhouette rises from bottom with glow ---
	# Create ghost boss sprite
	var boss_ghost: Sprite2D = Sprite2D.new()
	boss_ghost.texture = BOSS_TEXTURE
	boss_ghost.scale = Vector2(0.72, 0.72)
	boss_ghost.modulate = Color(0.8, 0.1, 0.1, 0.0)
	boss_ghost.position = Vector2(cx, size.y + 120.0)
	boss_ghost.z_index = 195
	_cine_overlay.add_child(boss_ghost)
	var rise_tw: Tween = create_tween()
	rise_tw.tween_property(boss_ghost, "position", Vector2(cx, cy + 20.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rise_tw.parallel().tween_property(boss_ghost, "modulate", Color(0.9, 0.15, 0.15, 0.65), 0.8)
	await rise_tw.finished
	# Boss ghost pulses
	for i in range(3):
		var pulse_tw: Tween = create_tween()
		pulse_tw.tween_property(boss_ghost, "modulate", Color(1.0, 0.2, 0.2, 0.85), 0.15)
		pulse_tw.parallel().tween_property(boss_ghost, "scale", Vector2(2.0, 2.0), 0.15)
		pulse_tw.chain().tween_property(boss_ghost, "modulate", Color(0.8, 0.1, 0.1, 0.5), 0.15)
		pulse_tw.parallel().tween_property(boss_ghost, "scale", Vector2(1.8, 1.8), 0.15)
		await pulse_tw.finished

	# --- Phase 4: Lightning bolts (diagonal energy lines) ---
	for i in range(6):
		var bolt: ColorRect = ColorRect.new()
		bolt.color = Color(1.0, 0.4, 0.3, 0.9)
		var bx: float = _rng.randf_range(0.0, size.x)
		bolt.position = Vector2(bx, -10.0)
		bolt.size = Vector2(3.0, size.y + 20.0)
		bolt.rotation = _rng.randf_range(-0.3, 0.3)
		bolt.z_index = 196
		_cine_overlay.add_child(bolt)
		var bolt_tw: Tween = create_tween()
		bolt_tw.tween_property(bolt, "modulate:a", 0.0, 0.15).set_delay(0.05)
		bolt_tw.tween_callback(bolt.queue_free)
	_shake(0.15, 6.0)
	await get_tree().create_timer(0.3).timeout

	# --- Phase 5: Boss name slams in ---
	_cine_subtitle_label.text = boss_name
	_cine_subtitle_label.add_theme_color_override("font_color", Color("#ffcccc"))
	_cine_subtitle_label.modulate.a = 1.0
	_cine_subtitle_label.scale = Vector2(2.5, 2.5)
	_cine_subtitle_label.visible = true
	var name_tw: Tween = create_tween()
	name_tw.tween_property(_cine_subtitle_label, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	await name_tw.finished
	await get_tree().create_timer(0.7).timeout

	# --- Phase 6: Everything blasts out ---
	var exit_tw: Tween = create_tween()
	exit_tw.set_parallel(true)
	exit_tw.tween_property(_cine_title_label, "scale", Vector2(0.3, 3.0), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	exit_tw.tween_property(_cine_title_label, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
	exit_tw.tween_property(_cine_subtitle_label, "scale", Vector2(0.3, 3.0), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	exit_tw.tween_property(_cine_subtitle_label, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
	exit_tw.tween_property(boss_ghost, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25)
	exit_tw.tween_property(boss_ghost, "scale", Vector2(3.0, 3.0), 0.25)
	exit_tw.tween_property(_cine_overlay, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await exit_tw.finished

	# Cleanup
	if is_instance_valid(boss_ghost): boss_ghost.queue_free()
	if _cine_bg != null and is_instance_valid(_cine_bg): _cine_bg.queue_free()
	_cine_bg = null
	_cine_title_label.add_theme_color_override("font_color", Color("#f4fbff"))
	_cine_subtitle_label.add_theme_color_override("font_color", Color("#8fb8ff"))
	Audio.stop_cine_music()
	Audio.start_music()
	_cine_title_label.visible = false
	_cine_subtitle_label.visible = false
	_player.visible = true
	_cinematic_active = false


func _play_boss_defeat_cinematic() -> void:
	"""Anime-style boss defeat: freeze-frame, massive explosions, shockwave, text slam."""
	if Settings.reduce_motion:
		_animate_boss_victory()
		return
	_cinematic_active = true
	_player.visible = false
	_spawn_timer.stop(); _enemy_spawn_timer.stop()
	_clear_group("falling"); _clear_group("enemies"); _clear_group("enemy_bullets")
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5; var cy: float = size.y * 0.5
	var boss_pos: Vector2 = Vector2(cx, cy) if _boss == null else _boss.position

	# --- Phase 1: FREEZE FRAME flash (0.2s) ---
	Audio.play_cine_music("victory")
	Audio.play_sfx("boom")
	_boss_flash_rect.color = Color.WHITE
	_boss_flash_rect.modulate.a = 1.0
	await get_tree().create_timer(0.15).timeout
	# Rapid white → yellow → white strobe
	for i in range(4):
		_boss_flash_rect.color = Color.WHITE if i % 2 == 0 else Color(1.0, 0.95, 0.5, 1.0)
		_boss_flash_rect.modulate.a = 1.0 - float(i) * 0.15
		await get_tree().create_timer(0.04).timeout
	_shake(0.3, 12.0)
	# Flash fades out
	var flash_out: Tween = create_tween()
	flash_out.tween_property(_boss_flash_rect, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_OUT)

	# --- Phase 2: Massive multi-burst explosion ---
	_spawn_burst(boss_pos, Color("#ffd76b"))
	await get_tree().create_timer(0.08).timeout
	_spawn_burst(boss_pos + Vector2(-40.0, 20.0), Color("#ff6b6b"))
	_spawn_burst(boss_pos + Vector2(35.0, -15.0), Color("#ffaa44"))
	_shake(0.2, 8.0)
	await get_tree().create_timer(0.15).timeout
	_spawn_burst(boss_pos + Vector2(-20.0, -30.0), Color("#ff4444"))
	_spawn_burst(boss_pos + Vector2(25.0, 25.0), Color("#ffdd88"))
	_shake(0.25, 10.0)
	await get_tree().create_timer(0.2).timeout
	# Final big burst
	_spawn_burst(boss_pos, Color("#ffffff"))
	_shake(0.35, 14.0)
	# Shockwave ring (expanding circle)
	var ring: ColorRect = ColorRect.new()
	ring.color = Color(1.0, 0.9, 0.4, 0.7)
	ring.position = boss_pos - Vector2(5.0, 5.0)
	ring.size = Vector2(10.0, 10.0)
	ring.z_index = 180
	add_child(ring)
	var ring_tw: Tween = create_tween()
	ring_tw.set_parallel(true)
	ring_tw.tween_property(ring, "size", Vector2(600.0, 600.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	ring_tw.tween_property(ring, "position", boss_pos - Vector2(300.0, 300.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	ring_tw.tween_property(ring, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)
	ring_tw.tween_callback(ring.queue_free)
	await get_tree().create_timer(0.3).timeout

	# --- Phase 3: BOSS VAINCU slam (huge scale → slam) ---
	_boss_victory_label.text = Settings.loc("boss_victory")
	_boss_victory_label.modulate.a = 1.0
	_boss_victory_label.scale = Vector2(5.0, 5.0)
	_boss_victory_label.visible = true
	var slam_tw: Tween = create_tween()
	slam_tw.tween_property(_boss_victory_label, "scale", Vector2(1.0, 1.0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_shake(0.2, 10.0)
	await slam_tw.finished
	# Glow pulse
	for i in range(2):
		var gp: Tween = create_tween()
		gp.tween_property(_boss_victory_label, "scale", Vector2(1.08, 1.08), 0.15)
		gp.parallel().tween_property(_boss_victory_label, "modulate", Color("#fff8d0"), 0.15)
		gp.chain().tween_property(_boss_victory_label, "scale", Vector2(1.0, 1.0), 0.15)
		gp.parallel().tween_property(_boss_victory_label, "modulate", Color.WHITE, 0.15)
		await gp.finished
	await get_tree().create_timer(0.8).timeout

	# --- Phase 4: SECTEUR SUIVANT subtitle with energy particles ---
	_boss_victory_sub.text = Settings.loc("next_sector")
	_boss_victory_sub.modulate.a = 1.0
	_boss_victory_sub.scale = Vector2(0.0, 0.0)
	_boss_victory_sub.visible = true
	# Spawn small energy particles around the text
	for i in range(10):
		var ep: CPUParticles2D = CPUParticles2D.new()
		ep.amount = 8; ep.one_shot = true; ep.lifetime = 0.6; ep.explosiveness = 0.9
		ep.spread = 360.0; ep.gravity = Vector2.ZERO
		ep.initial_velocity_min = 30.0; ep.initial_velocity_max = 80.0
		ep.scale_amount_min = 1.5; ep.scale_amount_max = 3.0
		ep.color = COL_ACCENT
		ep.position = boss_pos + Vector2(_rng.randf_range(-80.0, 80.0), _rng.randf_range(-40.0, 40.0))
		add_child(ep); ep.emitting = true
		ep.get_tree().create_timer(1.0).timeout.connect(ep.queue_free)
	var sub_tw: Tween = create_tween()
	sub_tw.tween_property(_boss_victory_sub, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	await sub_tw.finished
	await get_tree().create_timer(0.8).timeout

	# --- Phase 5: Everything blasts away ---
	var exit_tw: Tween = create_tween()
	exit_tw.set_parallel(true)
	exit_tw.tween_property(_boss_victory_label, "scale", Vector2(0.3, 3.0), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	exit_tw.tween_property(_boss_victory_label, "modulate:a", 0.0, 0.3)
	exit_tw.tween_property(_boss_victory_sub, "scale", Vector2(0.3, 3.0), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	exit_tw.tween_property(_boss_victory_sub, "modulate:a", 0.0, 0.3)
	await exit_tw.finished

	Audio.stop_cine_music()
	Audio.start_music()
	_boss_victory_label.visible = false
	_boss_victory_sub.visible = false
	_player.visible = true
	_cinematic_active = false


# ---------------------------------------------------------------------------
# Story Cinematics
# ---------------------------------------------------------------------------

func _cine_cleanup_story(skip_btn: Button, click_area: Control, stars: Array, chars: Array, bobs: Array = []) -> void:
	"""Free all nodes created by the story cinematic."""
	for tw in bobs:
		if tw is Tween and is_instance_valid(tw): tw.kill()
	for tw in _cine_story_tweens:
		if tw is Tween and is_instance_valid(tw): tw.kill()
	_cine_story_tweens.clear()
	for s in stars:
		if is_instance_valid(s): s.queue_free()
	for ch in chars:
		if is_instance_valid(ch): ch.queue_free()
	if is_instance_valid(skip_btn): skip_btn.queue_free()
	if is_instance_valid(click_area): click_area.queue_free()
	if is_instance_valid(_cine_dialogue_panel): _cine_dialogue_panel.queue_free()
	_cine_dialogue_panel = null
	_cine_dialogue_name = null
	_cine_dialogue_text = null
	_cine_dialogue_hint = null
	if _cine_bg != null and is_instance_valid(_cine_bg): _cine_bg.queue_free()
	_cine_bg = null
	Audio.stop_cine_music()
	Audio.start_music()
	# Fade overlay out
	var fade: Tween = create_tween()
	fade.tween_property(_cine_overlay, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)


func _cine_bob(node: Node2D, amp: float, dur: float) -> Tween:
	"""Gentle hovering bob animation (killed by cleanup)."""
	var base: Vector2 = node.position
	var tw: Tween = create_tween().set_loops()
	tw.tween_property(node, "position", base + Vector2(0.0, amp), dur).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(node, "position", base - Vector2(0.0, amp), dur).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(node, "position", base, dur * 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_cine_story_tweens.append(tw)
	return tw


func _cine_make_drone() -> Sprite2D:
	"""Procedural companion drone: glowing cyan orb with ring and eye."""
	var drone: Sprite2D = Sprite2D.new()
	var img: Image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.0, 0.0, 0.0, 0.0))
	var c: Vector2 = Vector2(32.0, 32.0)
	for y in range(64):
		for x in range(64):
			var d: float = Vector2(x + 0.5, y + 0.5).distance_to(c)
			if d < 30.0:
				var a: float = clampf(1.0 - d / 30.0, 0.0, 1.0)
				img.set_pixel(x, y, Color(0.25, 0.75, 1.0, a * 0.5))
			if d > 20.0 and d < 24.0:
				img.set_pixel(x, y, Color(0.7, 0.95, 1.0, 1.0))
	# Eye (white dot)
	for y in range(64):
		for x in range(64):
			var e: float = Vector2(x + 0.5, y + 0.5).distance_to(c + Vector2(-8.0, -4.0))
			if e < 6.0:
				img.set_pixel(x, y, Color(0.9, 1.0, 1.0, 1.0))
	drone.texture = ImageTexture.create_from_image(img)
	drone.scale = Vector2(0.9, 0.9)
	return drone


func _cine_starfield_ambient(count: int) -> Array:
	"""Drifting starfield sprites for cinematic ambience."""
	var size: Vector2 = get_viewport_rect().size
	var stars: Array = []
	for i in range(count):
		var star: Sprite2D = Sprite2D.new()
		star.texture = STAR_TEXTURE
		var sc: float = _rng.randf_range(0.15, 0.5)
		star.scale = Vector2(sc, sc)
		star.position = Vector2(_rng.randf_range(0.0, size.x), _rng.randf_range(0.0, size.y))
		star.modulate = Color(0.7, 0.85, 1.0, _rng.randf_range(0.25, 0.7))
		star.z_index = 1
		_cine_overlay.add_child(star)
		var tw: Tween = star.create_tween().set_loops()
		var amp: float = _rng.randf_range(6.0, 18.0)
		var dur: float = _rng.randf_range(1.5, 3.5)
		tw.tween_property(star, "position:y", star.position.y - amp, dur).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tw.tween_property(star, "position:y", star.position.y + amp, dur).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		stars.append(star)
	return stars


func _cine_build_dialogue_box() -> void:
	"""Bottom dialogue box: speaker name + typewriter text + tap hint."""
	var panel: PanelContainer = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_left = 30.0; panel.offset_right = -30.0
	panel.offset_top = -150.0; panel.offset_bottom = -34.0
	panel.z_index = 205
	var sb: StyleBoxFlat = StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.04, 0.1, 0.92)
	sb.border_color = Color(0.2, 0.5, 0.9, 0.6)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(14)
	sb.content_margin_left = 20.0; sb.content_margin_right = 20.0
	sb.content_margin_top = 12.0; sb.content_margin_bottom = 12.0
	panel.add_theme_stylebox_override("panel", sb)
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	panel.add_child(vbox)
	# Speaker name
	var name_lbl: Label = Label.new()
	name_lbl.add_theme_font_size_override("font_size", 22)
	name_lbl.add_theme_color_override("font_color", Color("#4fd8ff"))
	name_lbl.add_theme_constant_override("outline_size", 5)
	name_lbl.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.9))
	vbox.add_child(name_lbl)
	# Body text
	var text_lbl: Label = Label.new()
	text_lbl.add_theme_font_size_override("font_size", 19)
	text_lbl.add_theme_color_override("font_color", Color("#dce8ff"))
	text_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_lbl.custom_minimum_size = Vector2(0.0, 44.0)
	vbox.add_child(text_lbl)
	# Tap hint
	var hint: Label = Label.new()
	hint.text = Settings.loc("cine_tap_hint")
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.4, 0.6, 0.9, 0.8))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	vbox.add_child(hint)
	_cine_overlay.add_child(panel)
	_cine_dialogue_panel = panel
	_cine_dialogue_name = name_lbl
	_cine_dialogue_text = text_lbl
	_cine_dialogue_hint = hint
	panel.visible = false


func _cine_say(speaker: String, text: String, color: Color, state: Array) -> void:
	"""Show a dialogue line with typewriter effect; wait for tap or timeout."""
	if state[0] or _cine_dialogue_panel == null:
		return
	_cine_dialogue_panel.visible = true
	_cine_dialogue_name.text = speaker
	_cine_dialogue_name.add_theme_color_override("font_color", color)
	_cine_dialogue_text.text = ""
	_cine_dialogue_hint.text = ""
	state[1] = false
	# Typewriter
	var chars: int = text.length()
	var idx: int = 0
	while idx < chars and not state[0] and not state[1]:
		_cine_dialogue_text.text = text.substr(0, idx + 1)
		idx += 1
		await get_tree().create_timer(0.025).timeout
	_cine_dialogue_text.text = text
	_cine_dialogue_hint.text = Settings.loc("cine_tap_hint")
	# Wait for tap or 4.5s
	var elapsed: float = 0.0
	state[1] = false
	while elapsed < 4.5 and not state[0] and not state[1]:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	# Fade the box out
	var out: Tween = create_tween()
	out.tween_property(_cine_dialogue_panel, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN)
	await out.finished
	if is_instance_valid(_cine_dialogue_panel):
		_cine_dialogue_panel.visible = false
		_cine_dialogue_panel.modulate.a = 1.0


func _play_story_cinematic() -> void:
	"""Three-act anime story: The Harvest, The Signal, The Scourge, The Mission."""
	_cinematic_active = true
	_player.visible = false
	_spawn_timer.stop(); _enemy_spawn_timer.stop()
	_clear_group("falling"); _clear_group("enemies"); _clear_group("enemy_bullets")
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5; var cy: float = size.y * 0.5
	_cine_overlay.color = Color(0.005, 0.008, 0.04, 1.0)
	_cine_overlay.modulate.a = 1.0
	_cine_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# ---- Input state (Array so lambdas can mutate it) ----
	var state: Array = [false, false]  # [skip, tap]
	# Skip button
	var skip_btn: Button = Button.new()
	skip_btn.text = Settings.loc("story_skip")
	skip_btn.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	skip_btn.offset_left = -150.0; skip_btn.offset_right = -20.0
	skip_btn.offset_top = -55.0; skip_btn.offset_bottom = -15.0
	var skip_sb: StyleBoxFlat = StyleBoxFlat.new()
	skip_sb.bg_color = Color(0.12, 0.14, 0.22, 0.8)
	skip_sb.corner_radius_top_left = 10; skip_sb.corner_radius_top_right = 10
	skip_sb.corner_radius_bottom_left = 10; skip_sb.corner_radius_bottom_right = 10
	skip_sb.content_margin_left = 14.0; skip_sb.content_margin_right = 14.0
	skip_sb.content_margin_top = 8.0; skip_sb.content_margin_bottom = 8.0
	skip_btn.add_theme_stylebox_override("normal", skip_sb)
	skip_btn.add_theme_color_override("font_color", Color("#7890b0"))
	skip_btn.z_index = 210
	_cine_overlay.add_child(skip_btn)
	# Click area (tap to advance)
	var click_area: Control = Control.new()
	click_area.set_anchors_preset(Control.PRESET_FULL_RECT)
	click_area.mouse_filter = Control.MOUSE_FILTER_STOP
	_cine_overlay.add_child(click_area)
	skip_btn.pressed.connect(func(): state[0] = true)
	click_area.gui_input.connect(func(event: InputEvent):
		if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
			state[1] = true)

	# ---- Dialogue box ----
	_cine_build_dialogue_box()

	# ---- Music & SFX ----
	Audio.play_cine_music("ambient")
	Audio.play_sfx("whoosh")

	# ---- Ambient starfield ----
	var stars: Array = _cine_starfield_ambient(28)

	# ============ ACT 1: THE HARVEST (calm, blue) ============
	_cine_overlay.color = Color(0.005, 0.01, 0.05, 1.0)
	_cine_bg_show(CINE_BG_HARVEST)
	# Hero ship enters from the right
	var hero: Sprite2D = Sprite2D.new()
	hero.texture = PLAYER_TEXTURE
	hero.scale = Vector2(0.35, 0.35)
	hero.position = Vector2(size.x + 80.0, cy - 40.0)
	hero.rotation = -0.25
	hero.z_index = 193
	_cine_overlay.add_child(hero)
	var hero_enter: Tween = create_tween()
	hero_enter.tween_property(hero, "position", Vector2(cx - 40.0, cy - 30.0), 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hero_enter.parallel().tween_property(hero, "rotation", 0.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await hero_enter.finished
	var hero_bob: Tween = _cine_bob(hero, 8.0, 1.6)
	# Crystal glints while harvesting
	for c in range(3):
		_story_particles(Color("#ffd76b"), 2, 8.0)
		await get_tree().create_timer(0.4).timeout
	# NOVA drone flies in from top-left and circles the ship
	var nova: Sprite2D = _cine_make_drone()
	nova.position = Vector2(-50.0, -50.0)
	nova.z_index = 195
	_cine_overlay.add_child(nova)
	var nova_in: Tween = create_tween()
	nova_in.tween_property(nova, "position", Vector2(cx + 120.0, cy - 150.0), 0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await nova_in.finished
	# Circle the ship once
	var orbit: Tween = create_tween()
	var pts: Array = [
		Vector2(cx + 140.0, cy - 60.0),
		Vector2(cx - 20.0, cy - 130.0),
		Vector2(cx - 120.0, cy - 30.0),
		Vector2(cx + 10.0, cy + 30.0),
		Vector2(cx + 130.0, cy - 40.0),
	]
	for p in pts:
		orbit.tween_property(nova, "position", p, 0.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await orbit.finished
	var nova_bob: Tween = _cine_bob(nova, 10.0, 1.3)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return

	# ---- Dialogue Act 1 ----
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_1a"), Color("#4fd8ff"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return
	# Ship turns slightly, harvests a crystal flying in
	var turn_tw: Tween = create_tween()
	turn_tw.tween_property(hero, "rotation", 0.2, 0.5).set_ease(Tween.EASE_IN_OUT)
	turn_tw.chain().tween_property(hero, "rotation", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	_story_particles(Color("#ffd76b"), 6, 14.0)
	await turn_tw.finished
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_1b"), Color("#4fd8ff"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return
	# The strange light appears in the distance (pulsing)
	var light: Sprite2D = Sprite2D.new()
	light.texture = STAR_TEXTURE
	light.scale = Vector2(0.9, 0.9)
	light.position = Vector2(size.x - 140.0, 80.0)
	light.modulate = Color(1.0, 0.9, 0.6, 0.0)
	light.z_index = 194
	_cine_overlay.add_child(light)
	var light_tw: Tween = create_tween().set_loops()
	light_tw.tween_property(light, "modulate:a", 0.9, 0.8)
	light_tw.tween_property(light, "modulate:a", 0.4, 0.8)
	_cine_story_tweens.append(light_tw)
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_1c"), Color("#aad4ff"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return

	# ============ ACT 2: THE SIGNAL (alarm, red) ============
	_cine_bg_show(CINE_BG_SIGNAL)
	# Red strobe + shake
	for i in range(5):
		_cine_overlay.color = Color(0.4, 0.0, 0.0, 1.0) if i % 2 == 0 else Color(0.15, 0.0, 0.0, 1.0)
		_shake(0.08, 4.0)
		await get_tree().create_timer(0.12).timeout
	_cine_overlay.color = Color(0.1, 0.0, 0.02, 1.0)
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_2a"), Color("#ff9a6b"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_2b"), Color("#ff5555"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return
	# Ship banks, engines flare
	var bank_tw: Tween = create_tween()
	bank_tw.tween_property(hero, "position", Vector2(cx - 80.0, cy - 20.0), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	bank_tw.parallel().tween_property(hero, "rotation", 0.3, 0.5).set_ease(Tween.EASE_IN_OUT)
	bank_tw.chain().tween_property(hero, "rotation", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	_story_speed_lines(Color("#ff6644"), 8)
	await bank_tw.finished
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_2c"), Color("#ff7777"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light], [hero_bob, nova_bob]); _cinematic_active = false; _player.visible = true; return

	# ============ ACT 3: THE SCOURGE (danger, dark red/purple) ============
	_cine_overlay.color = Color(0.05, 0.0, 0.06, 1.0)
	_cine_bg_show(CINE_BG_SCOURGE)
	# The Scourge rises from below, huge
	# The Scourge rises from below, huge
	var scourge: Sprite2D = Sprite2D.new()
	scourge.texture = BOSS_TEXTURE
	scourge.scale = Vector2(0.96, 0.96)
	scourge.position = Vector2(size.x - 160.0, size.y + 160.0)
	scourge.modulate = Color(1.0, 0.2, 0.15, 0.0)
	scourge.z_index = 192
	_cine_overlay.add_child(scourge)
	var scourge_rise: Tween = create_tween()
	scourge_rise.tween_property(scourge, "position", Vector2(size.x - 160.0, cy + 30.0), 1.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scourge_rise.parallel().tween_property(scourge, "modulate:a", 1.0, 1.0)
	await scourge_rise.finished
	_shake(0.25, 6.0)
	var scourge_bob: Tween = _cine_bob(scourge, 12.0, 2.2)
	# Lightning bolts
	_story_speed_lines(Color("#ff3355"), 10)
	await _cine_say(Settings.loc("cine_scourge_name"), Settings.loc("cine_line_3a"), Color("#ff4444"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light, scourge], [hero_bob, nova_bob, scourge_bob]); _cinematic_active = false; _player.visible = true; return
	await _cine_say(Settings.loc("cine_nova_name"), Settings.loc("cine_line_3b"), Color("#8fd0ff"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light, scourge], [hero_bob, nova_bob, scourge_bob]); _cinematic_active = false; _player.visible = true; return

	# ============ ACT 4: THE MISSION (resolve, launch) ============
	_cine_overlay.color = Color(0.0, 0.01, 0.06, 1.0)
	_cine_bg_show(CINE_BG_LAUNCH)
	# Hero turns to face the Scourge
	# Hero turns to face the Scourge
	var face_tw: Tween = create_tween()
	face_tw.tween_property(hero, "position", Vector2(cx - 120.0, cy - 10.0), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	face_tw.parallel().tween_property(hero, "rotation", 0.15, 0.4).set_ease(Tween.EASE_IN_OUT)
	face_tw.chain().tween_property(hero, "rotation", -0.05, 0.4).set_ease(Tween.EASE_IN_OUT)
	await face_tw.finished
	await _cine_say(Settings.loc("cine_pilot_name"), Settings.loc("cine_line_4a"), Color("#ffd76b"), state)
	if state[0]: _cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light, scourge], [hero_bob, nova_bob, scourge_bob]); _cinematic_active = false; _player.visible = true; return
	# Charge: speed lines, ship blasts upward
	_story_speed_lines(Color("#00ccff"), 26)
	_shake(0.3, 5.0)
	var charge_tw: Tween = create_tween()
	charge_tw.tween_property(hero, "position", Vector2(cx, -80.0), 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	charge_tw.parallel().tween_property(hero, "scale", Vector2(1.1, 1.1), 0.8)
	await charge_tw.finished
	# Title slam
	_cine_title_label.text = Settings.loc("cine_title_main")
	_cine_title_label.add_theme_color_override("font_color", Color("#ffd76b"))
	_cine_title_label.modulate.a = 1.0
	_cine_title_label.scale = Vector2(3.0, 3.0)
	_cine_title_label.visible = true
	var title_tw: Tween = create_tween()
	title_tw.tween_property(_cine_title_label, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_shake(0.2, 8.0)
	await title_tw.finished
	# Subtitle fades in
	_cine_subtitle_label.text = Settings.loc("cine_title_sub")
	_cine_subtitle_label.add_theme_color_override("font_color", Color("#8fb8ff"))
	_cine_subtitle_label.modulate.a = 0.0
	_cine_subtitle_label.visible = true
	var sub_tw: Tween = create_tween()
	sub_tw.tween_property(_cine_subtitle_label, "modulate:a", 1.0, 0.7).set_ease(Tween.EASE_OUT)
	await sub_tw.finished
	await get_tree().create_timer(1.0).timeout
	# White flash out
	_boss_flash_rect.modulate.a = 1.0
	var flash_out: Tween = create_tween()
	flash_out.tween_property(_boss_flash_rect, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_OUT)
	await flash_out.finished
	_cine_cleanup_story(skip_btn, click_area, stars, [hero, nova, light, scourge], [hero_bob, nova_bob, scourge_bob])
	_cine_title_label.visible = false
	_cine_subtitle_label.visible = false
	_cine_title_label.add_theme_color_override("font_color", Color("#f4fbff"))
	_cine_subtitle_label.add_theme_color_override("font_color", Color("#8fb8ff"))
	Settings.story_shown = true
	Settings.save()
	Audio.stop_cine_music()
	Audio.start_music()
	_player.visible = true
	_cinematic_active = false


func _play_zone_transition_cinematic(zone_index: int) -> void:
	"""Anime-style zone transition: warp tunnel, ship flythrough, dramatic zone reveal."""
	_cinematic_active = true
	_player.visible = false
	var size: Vector2 = get_viewport_rect().size
	var cx: float = size.x * 0.5; var cy: float = size.y * 0.5

	# --- Phase 1: Warp tunnel effect ---
	Audio.play_cine_music("warp")
	Audio.play_sfx("whoosh")
	_cine_overlay.color = Color(0.01, 0.005, 0.04, 0.95)
	_cine_overlay.modulate.a = 1.0
	_cine_bg_show(ZONE_BG_TEXTURES[zone_index % ZONE_BG_TEXTURES.size()], 0.7)
	# Concentric rings expanding outward (warp tunnel)
	for i in range(6):
		var ring: ColorRect = ColorRect.new()
		var zone_col: Color = COL_ACCENT if i % 2 == 0 else COL_VIOLET
		ring.color = Color(zone_col.r, zone_col.g, zone_col.b, 0.0)
		ring.position = Vector2(cx - 3.0, cy - 3.0)
		ring.size = Vector2(6.0, 6.0)
		ring.z_index = 190
		_cine_overlay.add_child(ring)
		var delay: float = float(i) * 0.12
		var r_tw: Tween = create_tween()
		r_tw.tween_property(ring, "size", Vector2(1200.0, 1200.0), 0.8).set_delay(delay).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		r_tw.parallel().tween_property(ring, "position", Vector2(cx - 600.0, cy - 600.0), 0.8).set_delay(delay).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		r_tw.parallel().tween_property(ring, "modulate:a", 0.4 - float(i) * 0.05, 0.3).set_delay(delay)
		r_tw.chain().tween_property(ring, "modulate:a", 0.0, 0.4)
		r_tw.tween_callback(ring.queue_free)
	# Speed lines during tunnel
	for i in range(12):
		var sl: ColorRect = ColorRect.new()
		sl.color = Color(0.3, 0.5, 1.0, 0.0)
		sl.position = Vector2(_rng.randf_range(0.0, size.x), cy)
		sl.size = Vector2(1.5, _rng.randf_range(30.0, 100.0))
		sl.z_index = 191
		_cine_overlay.add_child(sl)
		var sl_tw: Tween = create_tween()
		sl_tw.tween_property(sl, "position:y", size.y + 100.0, _rng.randf_range(0.3, 0.6)).set_delay(float(i) * 0.05)
		sl_tw.parallel().tween_property(sl, "modulate:a", 0.7, 0.1)
		sl_tw.parallel().tween_property(sl, "size", Vector2(4.0, sl.size.y * 2.0), 0.3)
		sl_tw.chain().tween_property(sl, "modulate:a", 0.0, 0.2)
		sl_tw.tween_callback(sl.queue_free)
	_shake(0.4, 4.0)
	await get_tree().create_timer(0.6).timeout

	# --- Phase 2: Ship zooms through center (overlay hero, never the real player) ---
	var hero: Sprite2D = Sprite2D.new()
	hero.texture = _player_sprite.texture
	hero.scale = _player_sprite.scale * 2.4
	hero.modulate = _player_base_tint
	hero.position = Vector2(cx, cy)
	hero.z_index = 193
	_cine_overlay.add_child(hero)
	var zoom_tw: Tween = create_tween()
	zoom_tw.set_parallel(true)
	zoom_tw.tween_property(hero, "scale", _player_sprite.scale * 1.2, 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	zoom_tw.tween_property(hero, "position", Vector2(cx, cy + 40.0), 0.4)
	await zoom_tw.finished
	await get_tree().create_timer(0.15).timeout

	# --- Phase 3: Zone name SLAM ---
	_cine_title_label.text = Settings.loc("zone_intro_%d" % (zone_index % 5))
	_cine_title_label.add_theme_color_override("font_color", COL_ACCENT)
	_cine_title_label.modulate.a = 1.0
	_cine_title_label.scale = Vector2(0.0, 0.0)
	_cine_title_label.visible = true
	var name_tw: Tween = create_tween()
	name_tw.tween_property(_cine_title_label, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_shake(0.15, 6.0)
	await name_tw.finished
	# Glow pulse
	for i in range(2):
		var gp: Tween = create_tween()
		gp.tween_property(_cine_title_label, "scale", Vector2(1.06, 1.06), 0.12)
		gp.parallel().tween_property(_cine_title_label, "modulate", Color("#88eeff"), 0.12)
		gp.chain().tween_property(_cine_title_label, "scale", Vector2(1.0, 1.0), 0.12)
		gp.parallel().tween_property(_cine_title_label, "modulate", Color.WHITE, 0.12)
		await gp.finished

	# --- Phase 4: Sector number types in ---
	var cycle: int = (zone_index / 5) + 1
	var sub_text: String = "SECTEUR %d" % (zone_index + 1)
	if cycle > 1:
		sub_text += " — Cycle %d" % cycle
	_cine_subtitle_label.text = ""
	_cine_subtitle_label.modulate.a = 1.0
	_cine_subtitle_label.visible = true
	for ci in range(sub_text.length()):
		if not _cinematic_active: break
		_cine_subtitle_label.text = sub_text.substr(0, ci + 1)
		await get_tree().create_timer(0.035).timeout
	await get_tree().create_timer(0.8).timeout

	# --- Phase 5: Everything zooms away ---
	var exit_tw: Tween = create_tween()
	exit_tw.set_parallel(true)
	exit_tw.tween_property(_cine_title_label, "scale", Vector2(2.5, 2.5), 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	exit_tw.tween_property(_cine_title_label, "modulate:a", 0.0, 0.4)
	exit_tw.tween_property(_cine_subtitle_label, "modulate:a", 0.0, 0.3)
	exit_tw.tween_property(_cine_overlay, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	exit_tw.tween_property(hero, "position", Vector2(cx, -80.0), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	exit_tw.tween_property(hero, "scale", hero.scale * 1.3, 0.5).set_ease(Tween.EASE_IN)
	await exit_tw.finished

	# Cleanup
	if is_instance_valid(hero): hero.queue_free()
	if _cine_bg != null and is_instance_valid(_cine_bg): _cine_bg.queue_free()
	_cine_bg = null
	_cine_title_label.visible = false
	_cine_subtitle_label.visible = false
	Audio.stop_cine_music()
	Audio.start_music()
	_player.visible = true
	_reset_player_position()
	_cinematic_active = false


# ---------------------------------------------------------------------------
# Zones
# ---------------------------------------------------------------------------

func _zone_theme(index: int) -> Dictionary:
	return ZONE_THEMES[index % ZONE_THEMES.size()]


func _zone_speed_mult() -> float:
	return clampf(1.0 + float(_zone_index) * ZONE_SPEED_MULT_STEP, 1.0, ZONE_SPEED_MULT_MAX)


func _enemy_spawn_interval() -> float:
	return clampf(ENEMY_SPAWN_INTERVAL_BASE - float(_zone_index) * 0.18 - _difficulty * 0.05, ENEMY_SPAWN_INTERVAL_MIN, ENEMY_SPAWN_INTERVAL_BASE)


func _apply_zone(index: int, announce: bool) -> void:
	var theme: Dictionary = _zone_theme(index)
	var bg: Color = theme.get("bg", Color("#07101f"))
	var star_tint: Color = theme.get("star_tint", Color(1.0, 1.0, 1.0))
	if _starfield != null and _starfield.has_method("set_zone"):
		_starfield.set_zone(bg, star_tint, ZONE_BG_TEXTURES[index % ZONE_BG_TEXTURES.size()])
	Audio.set_music_zone(index)
	if announce:
		Audio.play_sfx("zone")
		var cycle: int = (index / ZONE_THEMES.size()) + 1
		var banner_text: String = "SECTEUR %d - %s" % [index + 1, String(theme.get("name", ""))]
		if cycle > 1:
			banner_text += " (Cycle %d)" % cycle
		_show_zone_banner(banner_text)


func _update_zone(delta: float) -> void:
	_zone_elapsed += delta
	if _boss_state != "" or _boss != null or _cinematic_active: return
	var threshold: float = ZONE_BOSS_TRIGGER_BASE + float(_zone_index) * ZONE_BOSS_TRIGGER_PER_ZONE
	if _zone_elapsed >= threshold:
		_zone_elapsed = 0.0
		_spawn_boss()


func _show_zone_banner(text: String) -> void:
	_zone_banner.text = text; _zone_banner.modulate.a = 1.0
	_zone_banner_timer = 2.6


func _update_zone_banner(delta: float) -> void:
	if _zone_banner_timer > 0.0:
		_zone_banner_timer = max(_zone_banner_timer - delta, 0.0)
		if _zone_banner_timer < 0.8:
			_zone_banner.modulate.a = _zone_banner_timer / 0.8
