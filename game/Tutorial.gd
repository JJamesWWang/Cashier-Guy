extends Node


var ui: Control
var dialogue_box: Panel
var active := false
var dialogue = [
	"manager Hey, Guy. Thank you for deciding to cover for our cashier today.",
	"manager Recently, we purchased this new cash register that I think you will find quite entertaining. It's kind of like a game! (It's weird how everything is gamified these days...)",
	"guy Just tell me how it works.",
	"manager In the middle of the screen here, the cash register shows you how much the customer paid and the price of the item.",
	"manager It also calculates the change due and the optimal way of making change for you.",
	"manager Then, here at the bottom is a scrolling indicator. You have to time your number presses correctly and enter them when the indicator is over the quantity you want.",
	"manager You can give it a try now if you want. Just hit any number on the keyboard and it will appear under the current quantity.",
	"guy (Why is this even a thing?)",
	"manager I'll leave the rest for you to figure out!",
	"guy (This register gives out change immediately after the indicator reaches the end. How unforgiving for mistakes...)",
	"guy (Well, no one actually looks at how much change they get right? Still, I should probably try to be as accurate as possible.)",
	"guy (I should also try to keep the bill and coin count low to be as efficient as possible.)",
	"customer Hello? You're kind of spacing out. Can you scan my item?",
	"guy (It's also probably bad to keep customers waiting...)",
	"customer You're absolutely correct in your thoughts, Guy.",
	"guy What.",
	"customer What you were just thinking about is related to the status bars to the left of the screen, was it not? Those indicate how satisfied people are.",
	"guy What are you talking about.",
	"customer Once your shift starts, a 5-minute timer will start ticking down and every 30 seconds something interesting will happen.",
	"customer Your goal is to last the entire time without letting the \"Guy\" or \"Manager\" status bars reach the left-most side.",
	"guy Yeah. Okay. Whatever you say.",
	"customer Watch out for the \"Customer\" bar as well, because if it reaches the left-most side, negative effects will carry over to the manager.",
	"customer So try to keep an eye on those statuses while you're trying to make change as quickly, accurately, and efficiently as possible!",
	"guy Yep. Mm-hmm. Thanks.",
	"guy ...",
	"guy (Finally, those guys are gone. Why are random people to telling me how to do my job?)",
]
var dialogue_index := 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_text") and active:
		if Animations.animating[dialogue_box.text]:
			Animations.skip_animate_text(dialogue_box.text)
		else:
			next_dialogue()
			SoundFX.play("SlotChange.wav", 1.5, -10)


func init(ui_: Control) -> void:
	ui = ui_
	dialogue_box = ui.dialogue_box
	active = false


func start_tutorial() -> void:
	active = true
	next_dialogue()


func next_dialogue() -> void:
	if dialogue_index < dialogue.size():
		var line = dialogue[dialogue_index]
		var name = line.split(" ")[0]
		var text = line.substr(len(name) + 1)
		dialogue_index += 1
		dialogue_box.call("dialogue_%s" % name, text)
		Animations.animate_text(dialogue_box.text)
	else:
		ui.set_fun_text("This concludes the tutorial. Press \"S\" to start Guy's shift.")


func stop_tutorial() -> void:
	active = false
