extends Node

var animating = {}

onready var text_animate_timer: Timer = $TextAnimateTimer


func animate_text(label: Label):
	if label in animating and animating[label]:
		animating[label] = false
		yield(get_tree().create_timer(0.1), "timeout")
	animating[label] = true

	for i in range(1, len(label.text) + 1):
		if not animating[label]:
			break
		label.visible_characters = i
		yield(text_animate_timer, "timeout")
	animating[label] = false


func skip_animate_text(label: Label):
	animating[label] = false
	label.visible_characters = -1
