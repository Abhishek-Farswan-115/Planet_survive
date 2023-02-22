@tool
class_name Planet extends Node3D

@export var generation_data: PlanetData:
	set(val):
		generation_data = val
		_on_planet_generation_data_changed()
		if generation_data != null and !(generation_data.is_connected("changed", Callable(self, "_on_planet_generation_data_changed"))):
			generation_data.changed.connect(Callable(self, "_on_planet_generation_data_changed"))

func _ready() -> void:
	_on_planet_generation_data_changed()

func _on_planet_generation_data_changed() -> void:
	for child in get_children():
		var face := child as PlanetMesh
		face.regenerate_mesh(generation_data)
