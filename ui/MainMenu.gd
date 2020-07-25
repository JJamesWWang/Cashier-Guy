extends Control


func _on_StartButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://game/Game.tscn")
	SoundFX.play("SlotChange.wav", 1.5, -10)
