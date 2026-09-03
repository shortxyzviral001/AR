extends SceneTree

var _main = null

func _init() -> void:
	# Manually register autoloads (script mode doesn't load them)
	var autoloads := {
		"Settings": "res://scripts/Settings.gd",
		"Leaderboard": "res://scripts/Leaderboard.gd",
		"Shop": "res://scripts/Shop.gd",
		"Audio": "res://scripts/Audio.gd",
		"AdsManager": "res://scripts/AdsManager.gd",
		"UpdateChecker": "res://scripts/UpdateChecker.gd",
	}
	for name in autoloads:
		var script: GDScript = load(autoloads[name])
		var node = script.new()
		node.name = name
		root.add_child(node)

	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value("settings", "story_shown", false)
	cfg.save("user://settings.cfg")

	var main_scene: PackedScene = load("res://scenes/Main.tscn")
	_main = main_scene.instantiate()
	root.add_child(_main)
	print("SMOKE: scene instantiated")
	await process_frame
	await process_frame
	_main.call("_start_game")
	print("SMOKE: start_game called")
	_run_poll()

func _run_poll() -> void:
	var frames: int = 0
	while frames < 3000:
		await process_frame
		frames += 1
		if frames % 600 == 0:
			print("SMOKE: frames=", frames, " cinematic_active=", _main.get("_cinematic_active"))
		if not _main.get("_cinematic_active"):
			print("SMOKE: cinematic finished after ", frames, " frames")
			break
	if is_instance_valid(_main):
		_main.queue_free()
	await process_frame
	print("SMOKE: DONE")
	quit(0)
