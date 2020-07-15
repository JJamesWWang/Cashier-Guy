extends Node2D

signal slot_changed(slot)

onready var slots: Array = [$Slot20, $Slot10, $Slot5, $Slot1,
							$SlotQ, $SlotD, $SlotN, $SlotP]


func get_slot(symbol: String) -> Slot:
	var slot = get_node("Slot" + symbol)
	return slot


func disable_tens(disable := true) -> void:
	$Slot10/Shape.disabled = disable
	$Slot1/Shape.disabled = disable
	$SlotD/Shape.disabled = disable
	$SlotP/Shape.disabled = disable


func _on_slot_entered(slot: Slot) -> void:
	emit_signal("slot_changed", slot)
