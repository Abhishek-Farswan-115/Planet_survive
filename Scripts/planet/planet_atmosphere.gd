@tool
class_name PlanetAtmosphere extends FogVolume

func regenerate_atmosphere(gen_data: PlanetData) -> void:
	material = null
	
	size = Vector3(gen_data.atmosphere_square_size, gen_data.atmosphere_square_size, gen_data.atmosphere_square_size)
	shape = RenderingServer.FOG_VOLUME_SHAPE_ELLIPSOID
	
	call_deferred("_finish_atmosphere_generation", gen_data)

func _finish_atmosphere_generation(gen_data: PlanetData) -> void:
	var mat := FogMaterial.new()
	mat.albedo = gen_data.atmosphere_albedo
	mat.emission = gen_data.atmosphere_emission
	mat.edge_fade = gen_data.atmosphere_curve
	mat.density = gen_data.atmosphere_density
	material = mat
