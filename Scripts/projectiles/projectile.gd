class_name Projectile extends RigidBody3D

@export_category("Parameters")
@export var speed: float = 30.0

var planet: Planet
var direction: Vector3

var planet_attraction: float = 9.8

var first_frame: bool = true
var spawn_height: float = 0.0

func _physics_process(_delta: float) -> void:
	if first_frame:
		apply_central_impulse(direction * speed)
		first_frame = false
