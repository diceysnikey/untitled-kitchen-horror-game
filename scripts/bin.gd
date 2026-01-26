extends Area2D

func _patty_entered(area: Area2D) -> void:
	var patty = area.get_parent()
	if patty.is_in_group("patty"):
		Signalbus.patty_entered_bin.emit(patty)
func _patty_exited(area: Area2D) -> void:
	var patty = area.get_parent()
	if patty.is_in_group("patty"):
		Signalbus.patty_exited_bin.emit(patty)

func _ready() -> void:
	area_entered.connect(_patty_entered)
	area_exited.connect(_patty_exited)
