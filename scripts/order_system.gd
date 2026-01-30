extends Node

var activeOrders := []

func _turn_active() -> void:
	$Timer.start(5)
func _turn_inactive() -> void:
	$Timer.stop()
func _add_order() -> void:
	var newOrder = OrderEntry.new()
	newOrder.name = "Patty"
	newOrder.value = randi_range(1, 2)
	activeOrders.append(newOrder)
	Signalbus.order_added.emit(newOrder)
	print("Added order")
	
func _check_submitted_order(sumbittedOrder: OrderEntry) -> void:
	var orderFound = false
	for order in activeOrders:
		if order.name == sumbittedOrder.name and order.value == sumbittedOrder.value:
			Signalbus.order_accepted.emit(order)
			activeOrders.erase(order)
			orderFound = true
			break
	if not orderFound:
		Signalbus.order_denied.emit()
		print("Order wrong")
		
func _ready() -> void:
	Signalbus.order_system_activated.connect(_turn_active)
	Signalbus.order_system_deactivated.connect(_turn_inactive)
	Signalbus.order_submitted.connect(_check_submitted_order)
	$Timer.timeout.connect(_add_order)
