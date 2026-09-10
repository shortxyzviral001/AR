extends Node

# Headless smoke test for the enhanced multi-phase boss fight.
# Usage: godot --headless res://tests/boss_smoke.tscn

var _main = null

func _ready() -> void:
	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value("settings", "story_shown", true)
	cfg.save("user://settings.cfg")
	Settings.story_shown = true

	var main_scene: PackedScene = load("res://scenes/Main.tscn")
	_main = main_scene.instantiate()
	add_child(_main)
	print("SMOKE: scene instantiated")
	_run_poll()

func _run_poll() -> void:
	var frames: int = 0
	while frames < 40:
		await get_tree().process_frame
		frames += 1
	_main.call("_start_game")
	print("SMOKE: start_game called")
	var start := Time.get_ticks_msec()
	while Time.get_ticks_msec() - start < 8000:
		await get_tree().process_frame
	# Force-spawn the boss directly (bypass the normal ~40s trigger) and
	# artificially damage it to exercise phase transitions + the telegraphed
	# ultimate attack quickly.
	_main.set("_zone_index", 0)
	_main.call("_spawn_boss")
	print("SMOKE: boss spawn requested")
	var spawn_wait := Time.get_ticks_msec()
	while Time.get_ticks_msec() - spawn_wait < 15000:
		await get_tree().process_frame
		if _main.get("_boss") != null:
			break
	print("SMOKE: boss state=", _main.get("_boss_state"), " boss=", _main.get("_boss"))
	# Drain HP down through phases 2 and 3 to trigger transitions + ultimate.
	var damage_start := Time.get_ticks_msec()
	while Time.get_ticks_msec() - damage_start < 15000:
		await get_tree().process_frame
		if _main.get("_boss") != null and is_instance_valid(_main.get("_boss")):
			_main.call("_damage_boss", 2.0)
		else:
			break
	print("SMOKE: final boss_phase=", _main.get("_boss_phase"), " boss_alive=", _main.get("_boss") != null)
	if is_instance_valid(_main):
		_main.queue_free()
	await get_tree().process_frame
	print("SMOKE: DONE")
	get_tree().quit(0)
