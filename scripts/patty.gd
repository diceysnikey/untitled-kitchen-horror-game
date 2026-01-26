extends Node2D

var mouseInside := false
var dragging := false
var distanceOffset := Vector2.ZERO
var cookedMeter = 0
var canCook = false
var canDispose = false

#Input Logic
func _mouse_entered() -> void:
	mouseInside = true
func _mouse_exited() -> void:
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

# Cook Logic
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
	elif cookedMeter == 80:
		$AnimatedSprite2D.play("burnt")

func _can_dispose(patty: Node2D) -> void:
	if self == patty:
		canDispose = true
func _cant_dispose(patty: Node2D) -> void:
	if self == patty:
		canDispose = false

func _ready() -> void:
	$AnimatedSprite2D.play("raw")
	$Area2D.mouse_entered.connect(_mouse_entered)
	$Area2D.mouse_exited.connect(_mouse_exited)
	Signalbus.start_cooking.connect(_can_cook)
	Signalbus.stop_cooking.connect(_cant_cook)
	Signalbus.patty_entered_bin.connect(_can_dispose)
	Signalbus.patty_exited_bin.connect(_cant_dispose)
	
func _process(delta: float) -> void:
	_input_logic()
	_cook_logic(delta)
	if canDispose and not dragging:
		queue_free()
	print("Cooked: " + str(snapped(cookedMeter, 0.01)))
