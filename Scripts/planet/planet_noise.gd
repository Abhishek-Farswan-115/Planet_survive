@tool
class_name PlanetNoise extends Resource

## Contains a layer of Noise classes. They will be combined additively, for now
@export var noise_layers: Array[PlanetNoiseLayer]:
	set(val):
		noise_layers = val
		for n in noise_layers:
			if n != null and !(n.is_connected("changed", Callable(self, "_on_data_changed"))):
				n.changed.connect(Callable(self, "_on_data_changed"))
		changed.emit()

## Amount of random noise to apply to single vertices, to give it a low-poly style. 
@export var random_noise_amount: float = 0.1:
	set(val):
		random_noise_amount = val
		changed.emit()

func _on_data_changed() -> void:
	changed.emit()
