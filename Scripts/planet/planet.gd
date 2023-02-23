@tool
class_name Planet extends Node3D

## Resource to be used to generate the planet. If you want to save the planet's parameters, you should save this resource to disk.
@export var generation_data: PlanetData:
	set(val):
		generation_data = val
		_on_planet_generation_data_changed()
		if generation_data != null and !(generation_data.is_connected("changed", Callable(self, "_on_planet_generation_data_changed"))):
			generation_data.changed.connect(Callable(self, "_on_planet_generation_data_changed"))

func _ready() -> void:
	_on_planet_generation_data_changed()

func _on_planet_generation_data_changed() -> void:
	if generation_data:
		generation_data.min_height = 1.79769e308
		generation_data.max_height = 0.0
	
	for child in get_children():
		if child is PlanetMesh:
			child.regenerate_mesh(generation_data)
		elif child is PlanetGravityArea:
			child.regenerate_gravity(generation_data)

func _on_gravity_area_body_entered(body: Node3D) -> void:
	if body is PlanetCharacter or body is Projectile:
		body.planet = self
		print(body.name)
