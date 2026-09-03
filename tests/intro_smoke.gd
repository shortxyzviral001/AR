extends Node

# Headless smoke test for the intro cinematic (force story_shown = true so the
# quick intro plays, then verify it completes without errors).
# Usage: godot --headless res://tests/intro_smoke.tscn

var _main = null

func _ready() -> void:
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
	while Time.get_ticks_msec() - start < 60000:
		await get_tree().process_frame
		if Time.get_ticks_msec() - start > 3000 and not _main.get("_cinematic_active"):
			print("SMOKE: intro cinematic finished after ", (Time.get_ticks_msec() - start) / 1000.0, "s")
			var rot: float = _main.get("_player").rotation
			print("SMOKE: player rotation after intro = ", rot)
			if absf(rot) > 0.001:
				print("SMOKE: FAIL - player still tilted")
				get_tree().quit(1)
				return
			break
	if is_instance_valid(_main):
		_main.queue_free()
	await get_tree().process_frame
	print("SMOKE: DONE")
	get_tree().quit(0)
