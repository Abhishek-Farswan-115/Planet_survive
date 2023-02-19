@tool
extends Camera3D

@export var sensitivity: = 0.01


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("lmb") and event is InputEventMouseMotion:
		position = position.rotated(
			Vector3.DOWN,
			event.relative.x * sensitivity
		)
		look_at(Vector3.ZERO)

