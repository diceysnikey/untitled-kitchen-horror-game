extends Area2D

func _start_cooking_patty(area: Area2D) -> void:
	var patty = area.get_parent()
	if patty.is_in_group("patty"):
		Signalbus.start_cooking.emit(patty)
func _stop_cooking_patty(area: Area2D) -> void:
	var patty = area.get_parent()
	if patty.is_in_group("patty"):
		Signalbus.stop_cooking.emit(patty)
	
func _ready() -> void:
	area_entered.connect(_start_cooking_patty)
	area_exited.connect(_stop_cooking_patty)
