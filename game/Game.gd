extends Node2D

var price := 0
var paid := 0
var change := 0

var mood_guy := 100
var mood_manager := 100
var mood_customer := 100

onready var ui: Control = $UI
onready var slots: Node2D = $Slots
onready var current_slot: Slot = $Slots/Slot20


func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var number: String = InputParse.parse(event)
		if number != "-1":
			ui.add_to_slot(current_slot, number)
			current_slot.quantity = current_slot.quantity * 10 + int(number)


func handle_cycle() -> void:
	var player_change := calculate_change()
	if player_change != 0:
		print("Change: $%.2f" % (player_change / 100.0))
	else:
		pass
	reset_slots()


func calculate_change() -> int:
	var player_change := 0
	for slot in slots.slots:
		player_change += slot.quantity * slot.value
	return player_change


func reset_slots() -> void:
	for slot in slots.slots:
		slot.reset()
		ui.reset_slot(slot)


func _on_Slots_slot_changed(slot: Slot) -> void:
	current_slot = slot


func _on_SlotSelector_reset() -> void:
	handle_cycle()
