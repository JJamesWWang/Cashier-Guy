extends Control

onready var guy_indicator: TextureRect = $GuyIndicator
onready var manager_indicator: TextureRect = $ManagerIndicator
onready var customer_indicator: TextureRect = $CustomerIndicator


func change_mood(indicator: TextureRect, value: int):
	assert(0 <= value and value <= 200)
	indicator.rect_position.x = value
