class_name PlanetCharacter extends CharacterBody3D

@export_category("Parameters")
@export var planet: Node3D
@export var mass: float = 4.0

@export_category("Movement")
@export var speed:float = 5.0
@export var acceleration:float = 0.3
@export var deceleration:float = 0.3
@export var air_control:float = 0.1

@export var jump_impulse:float = 10.0

@export_category("Camera")
@export var sensitivity:float = 0.001
@export var position_interpolation:float = 0.3

const BASE_PLANET_FORCE = 1.0


@onready var orientation: Node3D = $orientation
@onready var camera: Node3D = $orientation/camera
@onready var camera_pitch: Node3D = $orientation/camera/camera_pitch

var move_vel : Vector3
var up_vel: Vector3
var in_floor: bool = true

var global_camera_basis: Basis
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	camera.top_level = true

func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, orientation.global_position, position_interpolation)
	camera.global_transform.basis = orientation.global_transform.basis

func _physics_process(delta: float) -> void:
	up_direction = (global_position - planet.global_position).normalized()
	transform.basis = Basis.looking_at(up_direction.cross(basis.x), up_direction)
	in_floor = is_on_floor()
	
	if !in_floor:
		up_vel += -up_direction * gravity * delta * mass
	else: up_vel = -up_direction * BASE_PLANET_FORCE
	
	if Input.is_action_just_pressed("jump") && in_floor:
		up_vel += up_direction * (jump_impulse +BASE_PLANET_FORCE)
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (orientation.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if in_floor:
		move_vel = lerp(move_vel, direction * speed, (acceleration if direction else deceleration))
	else:
		move_vel = lerp(move_vel, direction * speed, air_control * (acceleration if direction else deceleration))
	
	velocity = move_vel + up_vel
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		orientation.rotate_y(event.relative.x* -sensitivity)
		camera_pitch.rotate_x(event.relative.y *-sensitivity)
		camera_pitch.rotation.x = clamp(camera_pitch.rotation.x, deg_to_rad(-70.0), deg_to_rad(-60.0))
