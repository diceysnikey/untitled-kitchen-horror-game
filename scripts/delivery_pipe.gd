extends Area2D

func _check_items() -> void:
	var order = OrderEntry.new()
	order.value = 0
	var items = get_overlapping_areas()
	for item in items.filter(func(i): return i.get_parent().is_in_group("Patty")): 
		order.value += 1
	order.name = "Patty"
	Signalbus.order_submitted.emit(order)
	
func _order_accepted(order: OrderEntry) -> void:
	var areas = get_overlapping_areas()
	var counter = 0
	for area in areas:
		var item = area.get_parent()
		if item.is_in_group(order.name):
			item.queue_free()
			counter += 1
		elif counter > order.value:
			break
	print("Order accepted")
	
func _ready() -> void:
	$Button.pressed.connect(_check_items)
	Signalbus.order_accepted.connect(_order_accepted)
