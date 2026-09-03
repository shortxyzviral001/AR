extends Node

# Headless smoke test (run as a scene so autoloads load normally).
# Usage: godot --headless res://tests/cine_smoke.tscn

var _main = null

func _ready() -> void:
	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value("settings", "story_shown", false)
	cfg.save("user://settings.cfg")
	# Force the in-memory flag too (autoload already loaded the old value)
	Settings.story_shown = false

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
	while Time.get_ticks_msec() - start < 150000:
		await get_tree().process_frame
		if Time.get_ticks_msec() - start > 10000 and not _main.get("_cinematic_active"):
			print("SMOKE: cinematic finished after ", (Time.get_ticks_msec() - start) / 1000.0, "s")
			break
	if is_instance_valid(_main):
		_main.queue_free()
	await get_tree().process_frame
	print("SMOKE: DONE")
	get_tree().quit(0)
