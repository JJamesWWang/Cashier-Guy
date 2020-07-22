extends Control



func _on_PlayAgainButton_pressed() -> void:
	get_tree().change_scene("res://game/Game.tscn")


func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene("res://ui/MainMenu.tscn")
