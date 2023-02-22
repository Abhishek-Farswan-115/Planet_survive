@tool
class_name PlanetNoise extends Resource

@export var noise_layers: Array[PlanetNoiseLayer]:
	set(val):
		noise_layers = val
		for n in noise_layers:
			if n != null and !(n.is_connected("changed", Callable(self, "_on_data_changed"))):
				n.changed.connect(Callable(self, "_on_data_changed"))
		changed.emit()

@export var random_noise_amount: float = 0.1:
	set(val):
		random_noise_amount = val
		changed.emit()

func _on_data_changed() -> void:
	changed.emit()
