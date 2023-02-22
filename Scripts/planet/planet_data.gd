@tool
class_name PlanetData extends Resource

@export var radius: float = 5.0:
	set(val):
		radius = val
		changed.emit()

@export var resolution: int = 50:
	set(val):
		resolution = val
		changed.emit()

@export var noise: PlanetNoise:
	set(val):
		noise = val
		if noise != null and !(noise.is_connected("changed", Callable(self, "_on_data_changed"))):
				noise.changed.connect(Callable(self, "_on_data_changed"))
		changed.emit()

func _on_data_changed() -> void:
	changed.emit()

func point_on_planet(point_on_sphere: Vector3) -> Vector3:
	var height := 0.0
	for l in noise.noise_layers:
		if !l.noise_map: continue
		var layer_height := l.noise_map.get_noise_3dv(point_on_sphere)
		layer_height = (layer_height + 1.0) / 2.0
		layer_height *= l.noise_power
		layer_height = max(0.0, layer_height - l.min_noise_value)
		height += layer_height
	return point_on_sphere * radius * (height+1.0)

func apply_post_process(point: Vector3) -> Vector3:
	return point + Vector3(
		randf_range(-noise.random_noise_amount, noise.random_noise_amount),
		randf_range(-noise.random_noise_amount, noise.random_noise_amount),
		randf_range(-noise.random_noise_amount, noise.random_noise_amount))
