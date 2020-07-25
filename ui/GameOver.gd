extends Control

const WARNING_THRESHOLD1 = 134
const WARNING_THRESHOLD2 = 67

onready var dialogue_box: Panel = $VBoxContainer/DialogueBox
onready var scores_label: Label = $VBoxContainer/HBoxContainer/ScorePanel/ScoresLabel
onready var final_score_label: Label = $VBoxContainer/HBoxContainer/ScorePanel/FinalScoreLabel
onready var grade_label: Label = $VBoxContainer/HBoxContainer/ScorePanel/GradeLabel

func _ready() -> void:
	scores_label.text = (
		"  %d\n"
	  + "+ %d\n"
	  + "+ %d\n"
	  + "+ %d\n"
	  + "- %d\n"
	  + "- %d\n"
	  + "+ %d") % [
		HighScores.score, HighScores.mood_guy / 2.0 * 100, 
		HighScores.mood_manager / 2.0 * 100, HighScores.mood_customer / 2.0 * 100,
		HighScores.total_underpay, HighScores.total_overpay, 
		HighScores.survival_bonus]
	final_score_label.text = str(HighScores.final_score)
	grade_label.text = HighScores.grade
	
	if HighScores.survival_bonus != 0:
		if HighScores.mood_guy > WARNING_THRESHOLD1:
			dialogue_box.dialogue_guy("Easy. If only they paid me more for this.")
		elif HighScores.mood_guy > WARNING_THRESHOLD2:
			dialogue_box.dialogue_guy("That wasn't too bad, though I probably "
			+ "wouldn't do that again if I were asked to.")
		else:
			dialogue_box.dialogue_guy("That had to be the worst five hours "
			+ "in my entire life. I'm quitting this job; minimal wage just "
			+ "isn't worth this.")
	else:
		if HighScores.mood_guy > WARNING_THRESHOLD1:
			dialogue_box.dialogue_guy("That was kind of fun, actually. "
			+ "Too bad \"fun\" doesn't translate to a happy manager.")
		elif HighScores.mood_guy > WARNING_THRESHOLD2:
			dialogue_box.dialogue_guy("So maybe I made a bit too many mistakes. "
			+ "I blame the cash register. That thing was way too broken.")
		elif HighScores.mood_guy > 0:
			dialogue_box.dialogue_guy("That was such a stupid job. I'm glad "
			+ "I got fired.")
		else:
			dialogue_box.dialogue_guy("What a stupid job with a stupid "
			+ "cash register and a stupid manager and stupid customers.")

	Animations.animate_text(dialogue_box.text)


func _on_PlayAgainButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://game/Game.tscn")
	SoundFX.play("SlotChange.wav", 1.5, -10)


func _on_MainMenuButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://ui/MainMenu.tscn")
	SoundFX.play("SlotChange.wav", 1.5, -10)
