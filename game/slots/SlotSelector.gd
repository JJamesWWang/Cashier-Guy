extends Area2D

signal reset

var reverse: bool

export (int) var SPEED = 512
export (Vector2) var START
export (Vector2) var ALT_START

onready var raycast: RayCast2D = $Raycast


func _process(delta: float) -> void:
	position.x += SPEED * delta
	if raycast.is_colliding():
		if not reverse:
			position = START
		else:
			position = ALT_START
		emit_signal("reset")


func speed_up() -> void:
	SPEED *= 2


func reverse_direction() -> void:
	scale.x *= -1
	SPEED *= -1
	reverse = true
	
