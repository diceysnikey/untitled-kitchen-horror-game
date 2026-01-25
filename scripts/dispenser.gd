extends Area2D

var mouseInsideDispenser = false

func _mouse_entered_dispenser() -> void:
	mouseInsideDispenser = true
func _mouse_exited_dispenser() -> void:
	mouseInsideDispenser = false

func _spawn_patty() -> void:
	var rawPattyInstance = preload("res://scenes/raw_patty.tscn").instantiate()
	get_parent().add_child(rawPattyInstance)
	rawPattyInstance.position = get_global_mouse_position()

func _ready() -> void:
	mouse_entered.connect(_mouse_entered_dispenser)
	mouse_exited.connect(_mouse_exited_dispenser)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hold") and mouseInsideDispenser:
		_spawn_patty()
