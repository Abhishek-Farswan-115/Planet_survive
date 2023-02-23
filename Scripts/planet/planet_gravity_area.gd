@tool
class_name PlanetGravityArea extends Area3D

func regenerate_gravity(gen_data: PlanetData) -> void:
	call_deferred("_clean_gravity")
	if gen_data:
		var h := 0.0
		for l in gen_data.noise.noise_layers:
			var hl := l.noise_power - l.min_noise_value
			h += hl
		call_deferred("_create_gravity", gen_data.radius * h + gen_data.gravity_radius_offset)

func _create_gravity(area_radius: float) -> void:
	var col := CollisionShape3D.new()
	var col_sh := SphereShape3D.new()
	col_sh.radius = area_radius
	col.shape = col_sh
	col.shape.radius = area_radius
	gravity_point_unit_distance = area_radius
	add_child(col)
	col.owner = get_tree().edited_scene_root

func _clean_gravity() -> void:
	for child in get_children():
		child.queue_free()

