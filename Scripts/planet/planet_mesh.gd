@tool
class_name PlanetMesh extends MeshInstance3D

@export var normal: Vector3

func regenerate_mesh(gen_data: PlanetData) -> void:
	if !gen_data:
		call_deferred("_clean_mesh")
		return
	elif !gen_data.noise:
		call_deferred("_clean_mesh")
		return
	else:
		for n in gen_data.noise.noise_layers:
			if !n:
				call_deferred("_clean_mesh")
				return
	
	var mesh_arrays := []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	
	var vertex_array := PackedVector3Array()
	var index_array := PackedInt32Array()
	
	var resolution :int = gen_data.resolution
	var num_vertices : int = resolution * resolution
	var num_indices : int = (resolution - 1) * (resolution - 1) * 6
	
	vertex_array.resize(num_vertices)
	index_array.resize(num_indices)
	
	var axis_a := Vector3(normal.y, normal.z, normal.x)
	var axis_b : Vector3 = normal.cross(axis_a)
	
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	
	for y in range(resolution):
		for x in range(resolution):
			var i : int = x + y*resolution
			var percent := Vector2(x,y) / (resolution-1)
			
			var point_on_cube : Vector3 = normal + (percent.x-0.5) * 2.0 * axis_a + (percent.y-0.5) * 2.0 * axis_b
			var point_on_sphere: Vector3 = point_on_cube.normalized()
			var point_on_planet: Vector3 = gen_data.point_on_planet(point_on_sphere)
			
			if x != resolution-1 && x != 0 && y != 0 && y != resolution-1:
				point_on_planet = gen_data.apply_post_process(point_on_planet)
			
			st.add_vertex(point_on_planet)
			
			if x != resolution-1 and y != resolution-1:
				st.add_index(i+resolution)
				st.add_index(i+resolution+1)
				st.add_index(i)
				st.add_index(i+resolution+1)
				st.add_index(i+1)
				st.add_index(i)
	
	mesh_arrays[Mesh.ARRAY_VERTEX] = vertex_array
	mesh_arrays[Mesh.ARRAY_INDEX] = index_array
	
	st.generate_normals()
	mesh_arrays = st.commit_to_arrays()
	
	call_deferred("_update_mesh", mesh_arrays)

func _update_mesh(arrays: Array) -> void:
	var _mesh := ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = _mesh
	for child in get_children():
		child.queue_free()
	create_trimesh_collision()

func _clean_mesh() -> void:
	for child in get_children():
		child.queue_free()
	mesh = ArrayMesh.new()
