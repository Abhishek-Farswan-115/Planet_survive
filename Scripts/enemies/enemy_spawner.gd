class_name EnemySpawner extends Node

@export var planet: Planet
@export var player: PlanetCharacter

@export var amount: float = 50
@export var ray_offset: float = 10.0

var dm: Node3D

func _ready() -> void:
	var planet_pos := planet.global_position
	var player_pos := player.global_position
	
	var norm := (player_pos - planet_pos).normalized()
	var pos := norm * (ray_offset + planet.get_add_height())
	for i in range(amount):
		pos = pos.rotated(player.global_transform.basis.z, randf_range(-PI*2, PI*2))
		pos = pos.rotated(player.global_transform.basis.x, randf_range(-PI*2, PI*2))
		
		var deb_mesh := preload("res://Scenes/enemies/enemy.tscn").instantiate()
		add_child(deb_mesh)
		deb_mesh.position = pos + planet_pos
