extends RigidBody3D

@export var jump_force: = 30.0
@export var move_speed: = 10.0
@export var rotaion_speed: = 3.0

var local_gravity: Vector3
var _move_direction: Vector3
var _last_strong_direction: Vector3


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	local_gravity = state.total_gravity.normalized()
	
	if _move_direction.length() > 0.2:
		_last_strong_direction = _move_direction.normalized()
	
	_move_direction = _get_model_oriented_input()
	_orient_character_to_direction(_last_strong_direction, state.step)
	
	if is_jumping(state):
		apply_central_impulse(-local_gravity * jump_force)
	if is_on_floor(state):
		apply_central_force(_move_direction * move_speed * mass)


func _get_model_oriented_input() -> Vector3:
	var input_left_right: = (
		Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	) 
	var input_forward: = Input.get_action_strength("ui_up")
	var raw_input: = Vector2(input_left_right, input_forward)
	
	var input: = Vector3.ZERO
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)
	input = transform.basis * input
	
	return input


func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis: = -local_gravity.cross(direction)
	var rotation_basis: = Basis(left_axis, -local_gravity, direction).orthonormalized()

	transform.basis = Basis(transform.basis.get_rotation_quaternion()).slerp(
		Basis(transform.basis.get_rotation_quaternion()), delta * rotaion_speed
	)


func is_jumping(state: PhysicsDirectBodyState3D) -> bool:
	return state.get_contact_count() > 0


func is_on_floor(state: PhysicsDirectBodyState3D) -> bool:
	for contact in state.get_contact_count():
		var contract_normal = state.get_contact_local_normal(contact)
		if contract_normal.dot(-local_gravity) > 0.5:
			return true
	return false
