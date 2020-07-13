extends Node2D

var price : int
var paid : int
var change : int
var optimal: String

var slot_passes := 0
var mood_guy := 100
var mood_manager := 100
var mood_customer := 100

onready var ui: Control = $UI
onready var slots: Node2D = $Slots
onready var current_slot: Slot = $Slots/Slot20
onready var game_timer: Timer = $GameTimer
onready var fun_timer: Timer = $FunTimer


func _ready() -> void:
	randomize()
	generate_scenario()


func _process(_delta: float) -> void:
	ui.update_time(game_timer.time_left)
	if Input.is_action_just_pressed("reset_slots"):
		reset_slots()
	if Input.is_action_just_pressed("start_game"):
		start_timers()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var number: String = InputParse.parse(event)
		if number != "-1":
			ui.add_to_slot(current_slot, number)
			current_slot.quantity = current_slot.quantity * 10 + int(number)


func generate_scenario() -> void:
	price = randi() % 10000
	paid = randi() % (price - 1)
	change = price - paid
	calculate_optimal()
	ui.update_screen(price, paid, change, optimal)


func calculate_optimal() -> void:
	var twenties := 0
	var tens := 0
	var fives := 0
	var ones := 0
	var quarters := 0
	var dimes := 0
	var nickels := 0
	var pennies := 0
	var change_left := change
	while change_left >= 2000:
		twenties += 1
		change_left -= 2000
	while change_left >= 1000:
		tens += 1
		change_left -= 1000
	while change_left >= 500:
		fives += 1
		change_left -= 500
	while change_left >= 100:
		ones += 1
		change_left -= 100
	while change_left >= 25:
		quarters += 1
		change_left -= 25
	while change_left >= 10:
		dimes += 1
		change_left -= 10
	while change_left >= 5:
		nickels += 1
		change_left -= 5
	while change_left >= 1:
		pennies += 1
		change_left -= 1
	
	optimal = ""
	if twenties > 0:
		optimal += "%d $20" % twenties
	if tens > 0:
		if optimal != "":
			optimal += ", %d $10" % tens
		else:
			optimal += "%d $10" % tens
	if fives > 0:
		if optimal != "":
			optimal += ", %d $5" % fives
		else:
			optimal += "%d $5" % fives
	if ones > 0:
		if optimal != "":
			optimal += ", %d $1" % ones
		else:
			optimal += "%d $1" % ones
	if quarters > 0:
		if optimal != "":
			optimal += ", %d Q" % quarters
		else:
			optimal += "%d Q" % quarters
	if dimes > 0:
		if optimal != "":
			optimal += ", %d D" % dimes
		else:
			optimal += "%d D" % dimes
	if nickels > 0:
		if optimal != "":
			optimal += ", %d N" % nickels
		else:
			optimal += "%d N" % nickels
	if pennies > 0:
		if optimal != "":
			optimal += ", %d P" % pennies
		else:
			optimal += "%d P" % pennies


func start_timers() -> void:
	game_timer.start()
	fun_timer.start()


func handle_cycle() -> void:
	var player_change := calculate_change()
	if player_change != 0:
		print("Expected change: $%.2f" % (change / 100.0))
		print("Change: $%.2f" % (player_change / 100.0))
		reset_slots()
		generate_scenario()
	else:
		pass


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
