extends Control



func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://game/Game.tscn")
	SoundFX.play("Key.wav", 1.5, -10)


func _on_SettingsButton_pressed() -> void:
	pass # Replace with function body.
