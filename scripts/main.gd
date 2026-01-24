extends Node2D

var toggledFullscreen = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen") && toggledFullscreen == false:
		toggledFullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
		print(DisplayServer.window_get_mode())
	elif Input.is_action_just_pressed("fullscreen"):
		toggledFullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
