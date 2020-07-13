extends Node2D

signal slot_changed(slot)

onready var slots: Array = [$Slot20, $Slot10, $Slot5, $Slot1,
							$SlotQ, $SlotD, $SlotN, $SlotP]


func get_slot(symbol: String) -> Slot:
	var slot = get_node("Slot" + symbol)
	return slot


func _on_slot_entered(slot: Slot) -> void:
	emit_signal("slot_changed", slot)
