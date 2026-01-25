extends Node2D

var mouseInside := false
var dragging := false
var distanceOffset := Vector2.ZERO

func _mouse_entered() -> void:
	print("entered")
	mouseInside = true
func _mouse_exited() -> void:
	print("Exited")
	mouseInside = false
func _set_distanceOffset() -> void:
	distanceOffset = position - get_global_mouse_position()
func _input_logic() -> void:
	if Input.is_action_just_pressed("Hold") and mouseInside:
		dragging = true
		_set_distanceOffset()
	if Input.is_action_pressed("Hold") and dragging:
		position = get_global_mouse_position() + distanceOffset
	if Input.is_action_just_released("Hold"):
		dragging = false

func _ready() -> void:
	$Area2D.mouse_entered.connect(_mouse_entered)
	$Area2D.mouse_exited.connect(_mouse_exited)
	
func _process(_delta: float) -> void:
	_input_logic()
