class_name Projectile extends StaticBody3D

var planet: Node3D

var received_planet :bool:
	set(val):
		received_planet = val
		if val == true:
			_on_received_planet()

func _on_received_planet() -> void:
	print(planet)

func _physics_process(_delta: float) -> void:
	if planet && !received_planet:
		received_planet = true
	print(received_planet)
	position += -basis.z
