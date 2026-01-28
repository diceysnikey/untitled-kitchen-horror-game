extends Node2D

var mouseInside := false
var dragging := false
var distanceOffset := Vector2.ZERO
var cookedMeter = 0
var canCook = false
var canDispose = false
var cookStatus = 0 #0 raw, 1 grilled, 2 burnt
var isCameraUp = false

func _mouse_entered() -> void:
	mouseInside = true
func _mouse_exited() -> void:
	mouseInside = false
	
func _set_distanceOffset() -> void:
	distanceOffset = global_position - get_global_mouse_position()
	
func _border_logic() -> Vector2:
	var sprite = ($AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, 0).get_size() * $AnimatedSprite2D.scale) / 2
	var viewport = get_viewport_rect().size
	var camPos = get_viewport().get_camera_2d().global_position
	var positionTarget = get_global_mouse_position() + distanceOffset
	positionTarget.x = clamp(positionTarget.x, camPos.x - viewport.x / 2 + sprite.x, camPos.x + viewport.x / 2 - sprite.x)
	positionTarget.y = clamp(positionTarget.y, camPos.y - viewport.y / 2 + sprite.y, camPos.y + viewport.y / 2 - sprite.y)
	return positionTarget
	
func _input_logic() -> void:
	if Input.is_action_just_pressed("Hold") and mouseInside:
		dragging = true
		_set_distanceOffset()
	if Input.is_action_pressed("Hold") and dragging and not isCameraUp:
		global_position = _border_logic()
	if Input.is_action_just_released("Hold"):
		dragging = false

func _can_cook(patty: Node2D) -> void:
	if self == patty:
		canCook = true
func _cant_cook(patty: Node2D) -> void:
	if self == patty:
		canCook = false
		
func _cook_logic(delta) -> void:
	if canCook and not dragging:
		cookedMeter = clamp(cookedMeter + (5 * delta), 0, 80)
	if cookedMeter > 50 and cookedMeter < 80:
		$AnimatedSprite2D.play("grilled")
		cookStatus = 1
	elif cookedMeter == 80:
		$AnimatedSprite2D.play("burnt")
		cookStatus = 2

func _can_dispose(patty: Node2D) -> void:
	if self == patty:
		canDispose = true
func _cant_dispose(patty: Node2D) -> void:
	if self == patty:
		canDispose = false
		
func _camera_moved_up() -> void:
	isCameraUp = true
func _camera_moved_down() -> void:
	isCameraUp = false

func _ready() -> void:
	isCameraUp = false
	$AnimatedSprite2D.play("raw")
	$Area2D.mouse_entered.connect(_mouse_entered)
	$Area2D.mouse_exited.connect(_mouse_exited)
	Signalbus.start_cooking.connect(_can_cook)
	Signalbus.stop_cooking.connect(_cant_cook)
	Signalbus.patty_entered_bin.connect(_can_dispose)
	Signalbus.patty_exited_bin.connect(_cant_dispose)
	Signalbus.camera_moved_up.connect(_camera_moved_up)
	Signalbus.camera_moved_down.connect(_camera_moved_down)
	
func _process(delta: float) -> void:
	_input_logic()
	_cook_logic(delta)
	if canDispose and not dragging:
		queue_free()
	print("Cooked: " + str(snapped(cookedMeter, 0.01)))
