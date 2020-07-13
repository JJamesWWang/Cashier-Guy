extends VBoxContainer

onready var _screen = $Middle/RegisterTop/VBoxContainer/HBoxContainer/Screen
onready var time_label = $Middle/RegisterTop/VBoxContainer/TimeLabel
onready var amount_label = _screen.amount_label
onready var fun_label = _screen.fun_label
onready var optimal_label = _screen.optimal_label


func update_screen(price: int, paid: int, change: int, optimal: String):
	amount_label.text = "$%.2f\n$%.2f\n$%.2f" % [price / 100.0, paid / 100.0, change / 100.0]
	optimal_label.text = "Optimal change: %s" % optimal


func set_fun_text(text: String):
	fun_label.text = text


# Add (concatenate) a number to the slot quantity.
func add_to_slot(slot: Slot, number: String) -> void:
	var label: Label = _get_slot_label(slot)
	if label.text != "0":
		label.text = label.text + number
	else:
		label.text = number


# Change number of label back to 0
func reset_slot(slot: Slot) -> void:
	var label: Label = _get_slot_label(slot)
	label.text = "0"


func update_time(time: float) -> void:
	# warning-ignore-all:narrowing_conversion
	var minutes: int = time / 60
	var seconds: int = time - (60 * minutes)
	time_label.text = "%d:%02d" % [minutes, seconds]


func _get_slot_label(slot: Slot) -> Label:
	var label = get_node("VBoxContainer/Labels/Label" + slot.symbol)
	return label

