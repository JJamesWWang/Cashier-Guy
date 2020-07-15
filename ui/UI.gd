extends VBoxContainer

var change_visible := true

onready var time_label: Label = $Middle/RegisterTop/VBoxContainer/TimeLabel
onready var _screen = $Middle/RegisterTop/VBoxContainer/HBoxContainer/Screen
onready var amount_label: Label = _screen.amount_label
onready var fun_label: Label = _screen.fun_label
onready var optimal_label: Label = _screen.optimal_label
onready var status_bars: Control = $Middle/StatusBars


func update_screen(price: int, paid: int, change: int, optimal: Array):
	if change_visible:
		amount_label.text = "$%.2f\n$%.2f\n$%.2f" % [price / 100.0, paid / 100.0, change / 100.0]
	else:
		amount_label.text = "$%.2f\n$%.2f" % [price / 100.0, paid / 100.0]
	optimal_label.text = "Optimal change: %s" % format_optimal(optimal)


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


func hide_optimal(hide := true) -> void:
	optimal_label.visible = not hide


func hide_change(hide := true) -> void:
	change_visible = not hide


func _get_slot_label(slot: Slot) -> Label:
	var label = get_node("VBoxContainer/Labels/Label" + slot.symbol)
	return label

