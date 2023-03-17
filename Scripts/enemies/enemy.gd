class_name PlanetEnemy extends CharacterBody3D

@export_category("Parameters")
@export var mass: float = 4.0

@export_category("Movement")
@export var speed:float = 5.0
@export var acceleration:float = 0.3
@export var deceleration:float = 0.1
@export var air_control:float = 0.1
@export var jump_impulse:float = 10.0

@export_category("Visuals")
@export var mesh_inclination_amount: float = 0.2
@export var mesh_inclination_speed: float = 0.2

const BASE_PLANET_FORCE = 1.0

@onready var orientation: Node3D = $orientation
@onready var mesh: Node3D = $orientation/mesh

var planet: Planet

var input_dir: Vector2
var direction: Vector3
var move_vel : Vector3
var up_vel: Vector3
var in_floor: bool = true

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(_delta: float) -> void:	
	mesh.rotation.x = lerp(mesh.rotation.x, -input_dir.y * mesh_inclination_amount, mesh_inclination_speed)
	mesh.rotation.z = lerp(mesh.rotation.z, input_dir.x * mesh_inclination_amount, mesh_inclination_speed)

func _physics_process(delta: float) -> void:
	if !planet: return
	up_direction = (global_position - planet.global_position).normalized()
	transform.basis = Basis.looking_at(up_direction.cross(basis.x), up_direction)
	in_floor = is_on_floor()
	
	if !in_floor:
		up_vel += -up_direction * gravity * delta * mass
	else: up_vel = -up_direction * BASE_PLANET_FORCE
	
	if Input.is_action_just_pressed("jump") && in_floor:
		up_vel += up_direction * (jump_impulse + BASE_PLANET_FORCE)
	
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (orientation.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if in_floor:
		move_vel = lerp(move_vel, direction * speed, (acceleration if direction else deceleration))
	else:
		move_vel = lerp(move_vel, direction * speed, air_control * (acceleration if direction else deceleration))
	
	velocity = move_vel + up_vel
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot"):
		if planet:
			_create_projectile()

func _create_projectile() -> void:
	var proj := preload("res://Scenes/projectiles/projectile.tscn").instantiate()
	call_deferred("_finish_projectile_creation", proj)

func _finish_projectile_creation(proj: Projectile) -> void:
	get_tree().current_scene.add_child(proj)
	proj.planet = planet
	proj.direction = -orientation.global_transform.basis.z
	proj.global_position = global_position + proj.direction
	proj.global_transform.basis = Basis.looking_at(proj.direction, (proj.global_position - proj.planet.global_position))
