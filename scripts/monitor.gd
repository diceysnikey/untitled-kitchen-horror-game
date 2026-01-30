extends Node2D

var displayedOrders = []

func _add_order_to_list(order: OrderEntry) -> void:
	displayedOrders.append([order.name, order.value])
	_refresh_order_list()

func _remove_order_from_list(order: OrderEntry) -> void:
	displayedOrders.erase([order.name, order.value])
	_refresh_order_list()

func _refresh_order_list() -> void:
	$RichTextLabel.text = ""
	for order in displayedOrders:
		$RichTextLabel.append_text(order[0] + ": " + str(order[1]))
		$RichTextLabel.newline()

func _ready() -> void:
	Signalbus.order_added.connect(_add_order_to_list)
	Signalbus.order_accepted.connect(_remove_order_from_list)
