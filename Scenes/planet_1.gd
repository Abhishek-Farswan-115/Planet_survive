extends Node3D


func _on_gravity_apply_body_entered(body: Node3D) -> void:
	if "planet" in body:
		body.planet = self
