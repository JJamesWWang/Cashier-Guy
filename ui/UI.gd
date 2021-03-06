extends VBoxContainer

var change_visible := true
var value_reverse := false
var last_paid: int
var last_price: int
var last_change: int
var animating_labels := {}

onready var score_label: Label = $Middle/RegisterTop/VBoxContainer/TopHBoxContainer/ScoreLabel
onready var time_label: Label = $Middle/RegisterTop/VBoxContainer/TopHBoxContainer/TimeLabel
onready var _screen = $Middle/RegisterTop/VBoxContainer/HBoxContainer/Screen
onready var screen_label: Label = _screen.label
onready var amount_label: Label = _screen.amount_label
onready var fun_label: Label = _screen.fun_label
onready var optimal_label: Label = _screen.optimal_label
onready var status_bars: Control = $Middle/StatusBars
onready var slots: TextureRect = $VBoxContainer/ChangeSlots
onready var dialogue_box: Panel = $DialogueBox


func update_screen(paid: int, price: int, change: int, optimal: Array):
	if change_visible:
		amount_label.text = "$%.2f\n$%.2f\n$%.2f" % [paid / 100.0, price / 100.0, change / 100.0]
	else:
		if value_reverse:
			amount_label.text = "$%.2f\n$%.2f" % [price / 100.0, paid / 100.0]
		else:
			amount_label.text = "$%.2f\n$%.2f" % [paid / 100.0, price / 100.0]
	optimal_label.text = "Optimal change: %s" % format_optimal(optimal)
	last_paid = paid
	last_price = price
	last_change = change


func format_optimal(optimal: Array) -> String:
	var optimal_str = ""
	var twenties: int = optimal[0]
	var tens: int = optimal[1]
	var fives: int = optimal[2]
	var ones: int = optimal[3]
	var quarters: int = optimal[4]
	var dimes: int = optimal[5]
	var nickels: int = optimal[6]
	var pennies: int = optimal[7]
	if twenties > 0:
		optimal_str += "%d $20" % twenties
	if tens > 0:
		if optimal_str != "":
			optimal_str += ", %d $10" % tens
		else:
			optimal_str += "%d $10" % tens
	if fives > 0:
		if optimal_str != "":
			optimal_str += ", %d $5" % fives
		else:
			optimal_str += "%d $5" % fives
	if ones > 0:
		if optimal_str != "":
			optimal_str += ", %d $1" % ones
		else:
			optimal_str += "%d $1" % ones
	if quarters > 0:
		if optimal_str != "":
			optimal_str += ", %d Q" % quarters
		else:
			optimal_str += "%d Q" % quarters
	if dimes > 0:
		if optimal_str != "":
			optimal_str += ", %d D" % dimes
		else:
			optimal_str += "%d D" % dimes
	if nickels > 0:
		if optimal_str != "":
			optimal_str += ", %d N" % nickels
		else:
			optimal_str += "%d N" % nickels
	if pennies > 0:
		if optimal_str != "":
			optimal_str += ", %d P" % pennies
		else:
			optimal_str += "%d P" % pennies
	return optimal_str


func set_fun_text(text: String):
	fun_label.text = text
	Animations.animate_text(fun_label)


# Add (concatenate) a number to the slot quantity.
func set_slot(slot: Slot, number: String) -> void:
	var label: Label = _get_slot_label(slot)
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


func update_score(score: int) -> void:
	score_label.text = "Score: " + str(score)


func update_moods(mood_guy: int, mood_manager: int, mood_customer: int):
	status_bars.change_mood(status_bars.guy_indicator, mood_guy)
	status_bars.change_mood(status_bars.manager_indicator, mood_manager)
	status_bars.change_mood(status_bars.customer_indicator, mood_customer)


func hide_optimal(hide := true) -> void:
	optimal_label.modulate.a = 0 if hide else 255


# It doesn't make sense to hide change when optimal is visible.
# PRE-CONDITION: optimal_label.modulate.a = 0
func hide_change(hide := true) -> void:
	change_visible = not hide
	screen_label.text = "Amount Paid:\nItem Price:"
	amount_label.text = "$%.2f\n$%.2f" % [last_paid / 100.0, last_price / 100.0]


func disable_tens(disable := true) -> void:
	var slot_numbers = slots.get_node("Labels")
	slot_numbers.get_node("Label10").modulate.a = 0 if disable else 255
	slot_numbers.get_node("Label1").modulate.a = 0 if disable else 255
	slot_numbers.get_node("LabelD").modulate.a = 0 if disable else 255
	slot_numbers.get_node("LabelP").modulate.a = 0 if disable else 255
	slots.texture.atlas = load("res://ui/textures/ChangeSlotsHalf.png")


func change_slots(slot: Slot, tens_disabled: bool):
	var y_pos := 0
	match slot.symbol:
		"20":
			y_pos = 0 if not tens_disabled else 140
		"10":
			y_pos = 140 if not tens_disabled else 0
		"5":
			y_pos = 280 if not tens_disabled else 280
		"1":
			y_pos = 420 if not tens_disabled else 0
		"Q":
			y_pos = 560 if not tens_disabled else 420
		"D":
			y_pos = 700 if not tens_disabled else 0
		"N":
			y_pos = 840 if not tens_disabled else 560
		"P":
			y_pos = 980 if not tens_disabled else 0
	slots.texture.region = Rect2(0, y_pos, 1280, 140)


# It doesn't make sense to reverse when change is visible.
# PRE-CONDITION: change_visible = false
func reverse_values(reverse := true) -> void:
	value_reverse = reverse
	screen_label.text = "Item Price:\nAmount Paid:"
	amount_label.text = "$%.2f\n$%.2f" % [last_price / 100.0, last_paid / 100.0]


func hide_slot_numbers(hide := true) -> void:
	var slot_numbers = slots.get_node("Labels")
	for child in slot_numbers.get_children():
		if child is Label:
			child.modulate.a = 0 if hide else 255


func hide_slot_labels(hide := true) -> void:
	var slot_labels = $VBoxContainer/Labels
	for child in slot_labels.get_children():
		if child is Label:
			child.modulate.a = 0 if hide else 255


func hide_timer(hide := true) -> void:
	time_label.modulate.a = 0 if hide else 255


func _get_slot_label(slot: Slot) -> Label:
	var label = get_node("VBoxContainer/Labels/Label" + slot.symbol)
	return label

