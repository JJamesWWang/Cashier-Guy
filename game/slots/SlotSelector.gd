extends Area2D

signal reset

export (int) var SPEED = 512
export (Vector2) var START

onready var raycast: RayCast2D = $Raycast


func _process(delta: float) -> void:
	position.x += SPEED * delta
	if raycast.is_colliding():
		position = START
		emit_signal("reset")
