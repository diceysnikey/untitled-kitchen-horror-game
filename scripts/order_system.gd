extends Node

var isActive = false
var orders := {}

func _turn_active() -> void:
	isActive = true
func _turn_inactive() -> void:
	isActive = false

func _ready() -> void:
	Signalbus.order_system_activated.connect(_turn_active)
	Signalbus.order_system_deactivated.connect(_turn_inactive)
