extends Node2D

const MAX_PRICE = 10000

var price : int
var paid : int
var change : int
var optimal: Array
var slot_passes := 0
var mood_guy: int = rand_range(100, 200)
var mood_manager: int = rand_range(100, 200)
var mood_customer: int = rand_range(100, 200)

onready var ui: Control = $UI
onready var slots: Node2D = $Slots
onready var current_slot: Slot = $Slots/Slot20
onready var game_timer: Timer = $GameTimer
onready var fun_timer: Timer = $FunTimer


func _ready() -> void:
	randomize()
	ui.status_bars.change_mood(ui.status_bars.guy_indicator, mood_guy)
	ui.status_bars.change_mood(ui.status_bars.manager_indicator, mood_manager)
	ui.status_bars.change_mood(ui.status_bars.customer_indicator, mood_customer)
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
	price = randi() % MAX_PRICE
	paid = randi() % (price - 1)
	change = price - paid
	calculate_optimal()
	ui.update_screen(price, paid, change, optimal)

# Use greedy algorithm for optimal change and store in var optimal
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
	
	optimal = [twenties, tens, fives, ones, quarters, dimes, nickels, pennies]


func start_timers() -> void:
	game_timer.start()
	fun_timer.start()


func handle_cycle() -> void:
	var player_change := calculate_change()
	if player_change != 0:
		update_moods(player_change)
		reset_slots()
		generate_scenario()
		slot_passes = 0
	else:
		slot_passes += 1

func calculate_change() -> int:
	var player_change := 0
	for slot in slots.slots:
		player_change += slot.quantity * slot.value
	return player_change


# Based on efficiency, speed, and accuracy, and current game state.
func update_moods(player_change: int):
	var mood_change := (MoodCalculator.check_efficiency(calculate_inefficiency())
					  + MoodCalculator.check_speed(slot_passes)
					  + MoodCalculator.check_accuracy(player_change - change))
	# Potentially make effects less effective at higher/lower moods
	# warning-ignore-all:narrowing_conversion
	mood_guy += mood_change.x
	mood_manager += mood_change.y
	mood_customer += mood_change.z
	ui.status_bars.change_mood(ui.status_bars.guy_indicator, mood_guy)
	ui.status_bars.change_mood(ui.status_bars.manager_indicator, mood_manager)
	ui.status_bars.change_mood(ui.status_bars.customer_indicator, mood_customer)


func calculate_inefficiency() -> int:
	var inefficiency := 0
	var i := 0
	for slot in slots.slots:
		inefficiency += slot.quantity - optimal[i]
		i += 1
	return inefficiency


func change_slots(slot: Slot):
	current_slot = slot


func reset_slots() -> void:
	for slot in slots.slots:
		slot.reset()
		ui.reset_slot(slot)


func fun1() -> void:
	ui.hide_optimal()


func fun2() -> void:
	ui.hide_change()


func _on_Slots_slot_changed(slot: Slot) -> void:
	change_slots(slot)


func _on_SlotSelector_reset() -> void:
	handle_cycle()
