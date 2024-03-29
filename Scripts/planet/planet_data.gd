@tool
class_name PlanetData extends Resource

## Base size of the planet. The planet will never be smaller than this, no matter what noise is being used
@export var radius: float = 5.0:
	set(val):
		radius = val
		changed.emit()

## Offset for the gravity area to be generated
@export var gravity_radius_offset: float = 20.0:
	set(val):
		gravity_radius_offset = val
		changed.emit()

## Subdivisions per projection mesh into the sphere. The higher it is, the more polygons that will be generated.
@export var resolution: int = 50:
	set(val):
		resolution = val
		changed.emit()

## Noise class to change a planet's height and shape properties.
@export var noise: PlanetNoise:
	set(val):
		noise = val
		if noise != null and !(noise.is_connected("changed", Callable(self, "_on_data_changed"))):
				noise.changed.connect(Callable(self, "_on_data_changed"))
		changed.emit()

@export_group("Visuals")
## Used within a shader to get the planet color based on vertex height. 0 means the lowest, 1 the highest one.
@export var height_gradient: GradientTexture1D:
	set(val):
		height_gradient = val
		if height_gradient != null and !(height_gradient.is_connected("changed", Callable(self, "_on_data_changed"))):
				height_gradient.changed.connect(Callable(self, "_on_data_changed"))

@export var slope_offset: float= 0.5:
	set(val):
		slope_offset = val
		changed.emit() 

## Used to determine what color should steep areas be.
@export_color_no_alpha var slope_albedo: Color = Color.DIM_GRAY:
	set(val):
		slope_albedo = val
		changed.emit()

@export_group("Atmosphere", "atmosphere")
## Defines the maximum  height of the atmosphere
@export var atmosphere_square_size: float = 100.0:
	set(val):
		atmosphere_square_size = val
		changed.emit()

@export var atmosphere_density: float = 0.1:
	set(val):
		atmosphere_density = val
		changed.emit()

@export var atmosphere_curve: float = 2.0:
	set(val):
		atmosphere_curve = val
		changed.emit()

@export_color_no_alpha var atmosphere_albedo: Color = Color.DEEP_SKY_BLUE:
	set(val):
		atmosphere_albedo = val
		changed.emit()

@export_color_no_alpha var atmosphere_emission: Color = Color.DEEP_SKY_BLUE:
	set(val):
		atmosphere_emission = val
		changed.emit()

var add_height: float = 0

var min_height: float = 1.79769e308
var max_height: float = 0.0

func _init() -> void:
	resource_local_to_scene = true

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
	add_height = radius * (height +1.0)
	return point_on_sphere * radius * (height+1.0)

func apply_post_process(point: Vector3) -> Vector3:
	return point + Vector3(
		randf_range(-noise.random_noise_amount, noise.random_noise_amount),
		randf_range(-noise.random_noise_amount, noise.random_noise_amount),
		randf_range(-noise.random_noise_amount, noise.random_noise_amount))
