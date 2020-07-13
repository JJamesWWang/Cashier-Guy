extends Area2D
class_name Slot
# Slot is an area that contains a monetary value for making change.
# All values are in cents to avoid floating point errors.

signal slot_entered(slot)

export (int) var value
export (String) var symbol

var quantity: int


func reset() -> void:
	quantity = 0


# Only the selector is expected to enter a slot.
func _on_area_entered(_selector: Area2D) -> void:
	emit_signal("slot_entered", self)
