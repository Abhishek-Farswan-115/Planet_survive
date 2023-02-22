@tool
class_name PlanetNoiseLayer extends Resource

@export var noise_map: FastNoiseLite:
	set(val):
		noise_map = val
		if noise_map != null and !(noise_map.is_connected("changed", Callable(self, "_on_data_changed"))):
			noise_map.changed.connect(Callable(self, "_on_data_changed"))
		changed.emit()

@export var noise_power: float = 1.0:
	set(val):
		noise_power = val
		changed.emit()

@export var min_noise_value: float = 0.0:
	set(val):
		min_noise_value = val
		changed.emit()

func _on_data_changed() -> void:
	changed.emit()
