extends CanvasLayer

var speed := 1

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var accuracy_label: Label = $ColorRect1/AccuracyLabel
onready var efficiency_label: Label = $ColorRect2/EfficiencyLabel

func update_labels(accuracy: int, efficiency: int):
	if accuracy > 0:
		accuracy_label.text = "+$%.2f" % (abs(accuracy) / 100.0)
	elif accuracy < 0:
		accuracy_label.text = "-$%.2f" % (abs(accuracy) / 100.0)
	else:
		accuracy_label.text = "Perfect!"
	
	if efficiency > 0:
		efficiency_label.text = "+%d overflow" % efficiency
	elif efficiency < 0:
		efficiency_label.text = "+%d efficient!" % abs(efficiency)
	else:
		efficiency_label.text = "Efficient!"


func flash_and_fade() -> void:
	animation_player.play("Fade %d" % speed)
