extends Node

const _file_path := "res://game/Tutorial.txt"

var ui: Control
var dialogue_box: Panel
var active := false
var err: int

var _dialogue: File

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_text") and active:
		if Animations.animating[dialogue_box.text]:
			Animations.skip_animate_text(dialogue_box.text)
		else:
			next_dialogue()


func init(ui_: Control) -> void:
	ui = ui_
	dialogue_box = ui.dialogue_box
	active = false
	_dialogue = File.new()
	err = _dialogue.open(_file_path, File.READ)
	if err != OK:
		dialogue_box.dialogue_manager("I can't find where I put my Tutorial.txt file, and I don't remember how the cash register works by memory, so you're on your own, Guy.")
		Animations.animate_text(dialogue_box.text)

func start_tutorial() -> void:
	if err == OK:
		active = true
		next_dialogue()


func next_dialogue() -> void:
	if not _dialogue.eof_reached():
		var line = _dialogue.get_line()
		var name = line.split(" ")[0]
		var text = line.substr(len(name) + 1)
		dialogue_box.call("dialogue_%s" % name, text)
		Animations.animate_text(dialogue_box.text)
	else:
		ui.set_fun_text("This concludes the tutorial. Press \"S\" to start Guy's shift.")


func stop_tutorial() -> void:
	if err == OK:
		active = false
		_dialogue.close()
