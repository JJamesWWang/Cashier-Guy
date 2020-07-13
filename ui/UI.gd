extends VBoxContainer


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


func _get_slot_label(slot: Slot) -> Label:
	var label = get_node("VBoxContainer/Labels/Label" + slot.symbol)
	return label

