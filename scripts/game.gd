extends Node2D

var isFullscreen = false
var isCameraUp = false
const cameraMoveDistance = 782

func _check_fullscreen_input() -> void:
	if Input.is_action_just_pressed("fullscreen") && isFullscreen == false:
		isFullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("fullscreen"):
		isFullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)

func _check_camera_input() -> void:
	if Input.is_action_just_pressed("LookUp") and not isCameraUp:
		isCameraUp = true
		$Camera2D.position.y -= cameraMoveDistance
	elif Input.is_action_just_pressed("LookDown") and isCameraUp:
		isCameraUp = false
		$Camera2D.position.y += cameraMoveDistance

func _process(_delta: float) -> void:
	_check_fullscreen_input()
	_check_camera_input()
	
func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
