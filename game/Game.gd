extends Node2D

const MAX_PAID = 10000
const WARNING1_THRESHOLD = 134
const WARNING2_THRESHOLD = 67

var paid: int
var price: int
var change: int
var optimal: Array
var slot_passes := 0
var mood_guy: int
var mood_manager: int
var mood_customer: int
var fun_count := 1
var complex_change := false
var tens_disabled := false
var selector_reversed := false
var rush_hour := false
var guy_warning1 := false
var guy_warning2 := false
var manager_warning1 := false
var manager_warning2 := false
var customer_warning1 := false
var customer_warning2 := false
var customer_warning3 := false

onready var MoodCalculator := $MoodCalculator
onready var InputParse := $InputParse
onready var Tutorial := $Tutorial
onready var ui: Control = $UI
onready var overhead: CanvasLayer = $Overhead
onready var slots: Node2D = $Slots
onready var selector: Area2D = $SlotSelector
onready var current_slot: Slot = $Slots/Slot20
onready var game_timer: Timer = $GameTimer
onready var fun_timer: Timer = $FunTimer


func _ready() -> void:
	randomize()
	mood_guy = rand_range(150, 200)
	mood_manager = rand_range(150, 175)
	mood_customer = rand_range(150, 200)
	ui.update_moods(mood_guy, mood_manager, mood_customer)
	generate_scenario()
	ui.set_fun_text("To advance the text, press \"E\"\nTo skip the tutorial, press \"S\"")
	Tutorial.init(ui)
	Tutorial.start_tutorial()


func _process(_delta: float) -> void:
	ui.update_time(game_timer.time_left)
	if Input.is_action_just_pressed("reset_slots"):
		reset_slots()
	if Input.is_action_just_pressed("start_game"):
		Tutorial.stop_tutorial()
		start_game()
	if Input.is_action_just_pressed("fun"):
		fun_effect(fun_count)
		fun_count += 1


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var number: String = InputParse.parse(event)
		if number != "-1":
			if not tens_disabled:
				ui.set_slot(current_slot, number)
				current_slot.quantity = int(number)
				SoundFX.play("Key.wav", 1, -15)
			else:
				if not current_slot.symbol in ["10", "1", "D", "P"]:
					ui.set_slot(current_slot, number)
					current_slot.quantity = int(number)
					SoundFX.play("Key.wav", 1, -15)


func generate_scenario() -> void:
	while true:
		paid = randi() % MAX_PAID + 10
		price = randi() % (paid - 7) + 6
		if tens_disabled:
			paid -= paid % 5
			price -= price % 5
		change = paid - price
		calculate_optimal()
		if complex_change:
			if change > 2000 and optimal_sum() > 8 and optimal_possible():
				break
		else:
			break
	ui.update_screen(paid, price, change, optimal)

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
	while change_left >= 1000 and not tens_disabled:
		tens += 1
		change_left -= 1000
	while change_left >= 500:
		fives += 1
		change_left -= 500
	while change_left >= 100 and not tens_disabled:
		ones += 1
		change_left -= 100
	while change_left >= 25:
		quarters += 1
		change_left -= 25
	while change_left >= 10 and not tens_disabled:
		dimes += 1
		change_left -= 10
	while change_left >= 5:
		nickels += 1
		change_left -= 5
	while change_left >= 1 and not tens_disabled:
		pennies += 1
		change_left -= 1
	
	optimal = [twenties, tens, fives, ones, quarters, dimes, nickels, pennies]


func optimal_sum() -> int:
	var sum = 0
	for i in optimal:
		sum += i
	return sum


func optimal_possible() -> bool:
	for i in optimal:
		if i > 9:
			return false
	return true


func start_game() -> void:
	if game_timer.time_left == 0:
		game_timer.start()
		fun_timer.start()
		ui.hide_timer(false)
		ui.set_fun_text("Can you survive for 5 minutes?")
		ui.dialogue_box.dialogue_guy("This shouldn't be too bad.")
		Animations.animate_text(ui.dialogue_box.text)


func handle_cycle() -> void:
	var player_change := calculate_change()
	if player_change != 0:
		var accuracy = player_change - change
		var efficiency = calculate_inefficiency()
		if not Tutorial.active:
			update_moods(accuracy, efficiency)
			MoodCalculator.play_accuracy(accuracy)
		flash_results(accuracy, efficiency)
		commentary()
		reset_slots()
		generate_scenario()
		slot_passes = 0
	else:
		if not Tutorial.active:
			slow_penalty()
			slow_commentary()
			slot_passes += 1

	if mood_guy == 0 or mood_manager == 0:
		game_over()

func calculate_change() -> int:
	var player_change := 0
	for slot in slots.slots:
		player_change += slot.quantity * slot.value
	return player_change


func calculate_inefficiency() -> int:
	var inefficiency := 0
	var i := 0
	for slot in slots.slots:
		inefficiency += slot.quantity - optimal[i]
		i += 1
	return inefficiency


# Based on efficiency, speed, and accuracy, and current game state.
func update_moods(accuracy: int, efficiency: int):
	var mood_change = MoodCalculator.calculate_mood(accuracy, efficiency)
	# warning-ignore-all:narrowing_conversion
	mood_guy = clamp(mood_guy + mood_change.x, 0, 200)
	if mood_customer + mood_change.z < 0:
		mood_manager = clamp(mood_manager + mood_customer + mood_change.z, 0, 200)
	mood_manager = clamp(mood_manager + mood_change.y, 0, 200)
	mood_customer = clamp(mood_customer + mood_change.z, 0, 200)
	ui.update_moods(mood_guy, mood_manager, mood_customer)


func slow_penalty() -> void:
	var mood_change := Vector3()
	match slot_passes:
		0:
			pass
		1:
			if rush_hour:
				mood_change += Vector3(0, 0, -50)
		2:
			if rush_hour:
				mood_change += Vector3(0, 0, -70)
			else:
				mood_change += Vector3(0, 0, -20)
		3:
			if rush_hour:
				mood_change += Vector3(0, 0, -100)
			else:
				mood_change += Vector3(0, 0, -40)
		_:
			if rush_hour:
				mood_change += Vector3(0, 0, -150)
			else:
				mood_change += Vector3(0, 0, -80)
	mood_guy = clamp(mood_guy + mood_change.x, 0, 200)
	if mood_customer + mood_change.z < 0:
		mood_manager = clamp(mood_manager + mood_customer + mood_change.z, 0, 200)
	mood_manager = clamp(mood_manager + mood_change.y, 0, 200)
	mood_customer = clamp(mood_customer + mood_change.z, 0, 200)
	ui.update_moods(mood_guy, mood_manager, mood_customer)


func flash_results(accuracy: int, efficiency: int) -> void:
	overhead.update_labels(accuracy, efficiency)
	overhead.flash_and_fade()


func commentary():
	var dialogue_box = ui.dialogue_box
	var text_before = dialogue_box.text.text
	if not guy_warning2 and mood_guy < WARNING2_THRESHOLD:
		dialogue_box.dialogue_guy("Why do I keep messing up!?")
		guy_warning2 = true
		guy_warning1 = true
	elif not manager_warning2 and mood_manager < WARNING2_THRESHOLD:
		dialogue_box.dialogue_manager("If you keep this up, Guy, I'll have you fired!")
		manager_warning2 = true
		manager_warning1 = true
	elif not customer_warning2 and mood_customer < WARNING2_THRESHOLD:
		dialogue_box.dialogue_customer("Stop ripping us off!")
		customer_warning2 = true
		customer_warning1 = true
	elif not guy_warning1 and mood_guy < WARNING1_THRESHOLD:
		dialogue_box.dialogue_guy("Focus! Making accurate change is surprisingly hard.")
		guy_warning1 = true
	elif not manager_warning1 and mood_manager < WARNING1_THRESHOLD:
		dialogue_box.dialogue_manager("Why do you keep overpaying the customers? We earned that money!")
		manager_warning1 = true
	elif not customer_warning1 and mood_customer < WARNING1_THRESHOLD:
		dialogue_box.dialogue_customer("Think we wouldn't notice you're short changing us? You're wrong.")
		customer_warning1 = true

	if text_before != dialogue_box.text.text:
		Animations.animate_text(dialogue_box.text)


func slow_commentary() -> void:
	var dialogue_box = ui.dialogue_box
	var text_before = dialogue_box.text.text
	if not customer_warning3 and mood_customer == 0:
		dialogue_box.dialogue_manager("Guy! The customers are complaining to me about your lack of speed. Hurry up!")
		customer_warning3 = true
		customer_warning2 = true
		customer_warning1 = true
	if not customer_warning2 and mood_customer < WARNING2_THRESHOLD:
		dialogue_box.dialogue_customer("Can you go any slower!?")
		customer_warning2 = true
		customer_warning1 = true
	if not customer_warning1 and mood_customer < WARNING1_THRESHOLD:
		dialogue_box.dialogue_customer("I have places to go. Please hurry.")
		customer_warning1 = true
	if text_before != dialogue_box.text.text:
		Animations.animate_text(dialogue_box.text)


func change_slots(slot: Slot):
	current_slot = slot
	ui.change_slots(slot, tens_disabled)
	if slot == slots.get_slot("20") and not selector_reversed:
		handle_cycle()
	elif slot == slots.get_slot("P") and selector_reversed:
		handle_cycle()
	if not tens_disabled:
		SoundFX.play("SlotChange.wav", 0.7, -20)
	else:
		if slot.symbol in ["20", "5", "Q", "N"]:
			SoundFX.play("SlotChange.wav", 0.7, -20)


func reset_slots() -> void:
	for slot in slots.slots:
		slot.reset()
		ui.reset_slot(slot)


func game_won() -> void:
	print("Game won!")
	var err = get_tree().change_scene("res://ui/GameOver.tscn")
	if err != OK:
		ui.set_fun_text("I can't show you the game over screen, but you won.")


func game_over() -> void:
	game_timer.paused = true
	fun_timer.paused = true
	selector.stop()
	if mood_guy == 0 and mood_manager == 0:
		ui.dialogue_box.dialogue_guy("I've had enough of this nonsense. I quit.")
		Animations.animate_text(ui.dialogue_box.text)
		yield(get_tree().create_timer(7), "timeout")
		ui.dialogue_box.dialogue_manager("Good, your time here wasn't going to last much longer anyway.")
	elif mood_guy == 0:
		ui.dialogue_box.dialogue_guy("I've had enough of this nonsense. I quit.")
	elif mood_manager == 0:
		ui.dialogue_box.dialogue_manager("You've made too many mistakes, Guy. You're fired.")
	Animations.animate_text(ui.dialogue_box.text)
	yield(get_tree().create_timer(7), "timeout")
	var error = get_tree().change_scene("res://ui/GameOver.tscn")
	if error != OK:
		ui.set_fun_text("I can't show you the game over screen, but you lost.")
	


func fun_effect(number: int) -> void:
	match number:
		1:
			fun1()
		2:
			fun2()
		3:
			fun3()
		4:
			fun4()
		5:
			fun5()
		6:
			fun6()
		7:
			fun7()
		8:
			fun8()
		9:
			fun9()


func fun1() -> void:
	ui.hide_optimal()
	ui.set_fun_text("You can calculate the optimal change by taking the largest "
				  + "value smaller than your remaining change.")
	ui.dialogue_box.dialogue_guy("(Why did the optimal change just disappear?)")
	Animations.animate_text(ui.dialogue_box.text)


func fun2() -> void:
	selector.speed_up()
	Animations.text_animate_timer.wait_time = 0.03
	overhead.speed = 2
	ui.set_fun_text("It might be better to think things through before committing to making change.")
	ui.dialogue_box.dialogue_guy("(...Did the indicator just get faster or am I seeing things?)")
	Animations.animate_text(ui.dialogue_box.text)


func fun3() -> void:
	rush_hour = true
	ui.set_fun_text("The customers are rushing in. Try not to take too long.")
	ui.dialogue_box.dialogue_manager("How's it going, Guy? Looks like a lot of customers are coming in so you gotta speed things up.")
	Animations.animate_text(ui.dialogue_box.text)

# Must come after fun1
func fun4() -> void:
	ui.hide_change()
	ui.set_fun_text("You can subtract paid - price, or you can add to the price until it equals paid.")
	ui.dialogue_box.dialogue_guy("(Now the change is gone? Should I tell Manny? No, there's no time with all of these customers.)")
	Animations.animate_text(ui.dialogue_box.text)


func fun5() -> void:
	complex_change = true
	selector.speed_up()
	ui.set_fun_text("When short on time, it might be better to give good change instead of precise change. ")
	ui.dialogue_box.dialogue_guy("(What is actually going on? Why is this cash register making things so hard?)")
	Animations.animate_text(ui.dialogue_box.text)


# Must come after fun4
func fun6() -> void:
	ui.reverse_values()
	ui.set_fun_text("Always be prepared for malfunctions in technology.")
	ui.dialogue_box.dialogue_guy("(I don't like this.)")
	Animations.animate_text(ui.dialogue_box.text)


func fun7() -> void:
	selector.reverse_direction()
	selector_reversed = not selector_reversed
	ui.set_fun_text("There is always a trade off between thinking things through and doing things quickly.")
	ui.dialogue_box.dialogue_guy("(This is bad.)")
	Animations.animate_text(ui.dialogue_box.text)


func fun8() -> void:
	tens_disabled = true
	ui.disable_tens()
	ui.set_fun_text("The $10 bill, $1 bill, dime, and penny make it too easy to make inefficient change, don't you think?")
	ui.dialogue_box.dialogue_guy("(Okay, what the actual heck.)")
	Animations.animate_text(ui.dialogue_box.text)


func fun9() -> void:
	selector.speed_up()
	Animations.text_animate_timer.wait_time = 0.01
	overhead.speed = 3
	ui.set_fun_text("In the heat of the moment, you must remember to keep calm and focus on your task.")
	ui.dialogue_box.dialogue_guy("(I hate this job.)")
	Animations.animate_text(ui.dialogue_box.text)


func _on_Slots_slot_changed(slot: Slot) -> void:
	change_slots(slot)


func _on_FunTimer_timeout() -> void:
	fun_effect(fun_count)
	fun_count += 1


func _on_GameTimer_timeout() -> void:
	game_won()

