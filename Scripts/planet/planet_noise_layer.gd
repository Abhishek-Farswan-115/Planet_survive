@tool
class_name PlanetNoiseLayer extends Resource

## Noise function to use when generating vertex heights.
@export var noise_map: FastNoiseLite:
	set(val):
		noise_map = val
		if noise_map != null and !(noise_map.is_connected("changed", Callable(self, "_on_data_changed"))):
			noise_map.changed.connect(Callable(self, "_on_data_changed"))
		changed.emit()

## How much the noise function should affect terrain. Can be combined with min_noise_value to get the desired result.
@export var noise_power: float = 1.0:
	set(val):
		noise_power = val
		changed.emit()

## Limits the height of the terrain. The lower it is, the higher the terrain becomes. Can be used with noise_power to get the desired effect.
@export var min_noise_value: float = 0.0:
	set(val):
		min_noise_value = val
		changed.emit()

func _on_data_changed() -> void:
	changed.emit()
