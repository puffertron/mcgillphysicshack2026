extends Node3D

@export var fluid_point_scene: PackedScene
var fluid_points

func _ready():
	generate_field(Vector3i(10,10,10), 1)
	
func _process(delta):
	pass
	
func ortho_neighbor_grid() -> Array[Vector3i]:
	var neighbors
	for x in range(3):
		for y in range(3):
			for z in range(3):
				var p
				
	return neighbors
				
func get_point_at_pos(pos:Vector3i) -> FluidPoint:
	return fluid_points[pos.x][pos.y][pos.z]
		
"""returns an array of neighbors from a FluidPoint in along the X, Y and Z axes (No diagonals). """
func get_orthogonal_neighbors(point: FluidPoint) -> Array[FluidPoint]:
	var look_pos: Vector3i 
	var neighbor_pos = ortho_neighbor_grid()
	var neighbors 
	for p in neighbor_pos:
		var neighbor = get_point_at_pos(look_pos + neighbor_pos)
		neighbors.append(neighbor)
		
	return neighbors
		

func generate_field(size: Vector3i, cell_size: float):
	#fluid_points = size.z*[size.y*[size.x*[null]]]
	var z_array: Array[FluidPoint] = []
	z_array.resize(size.z)
	
	var y_array: Array[Array] = []
	y_array.resize(size.y)
	y_array.fill(z_array)
	
	var x_array: Array[Array] = []
	x_array.resize(size.x)
	x_array.fill(y_array)
	
	fluid_points = x_array
	print(fluid_points)
	for x in range(size.x):
		for y in range(size.y):
			for z in range (size.z):
				var new_point = fluid_point_scene.instantiate()
				new_point.call("setup", Vector3i(x,y,z), Vector3(x,y,z)*cell_size)
				new_point.domain = self
				add_child(new_point)
				fluid_points[x][y][z] = new_point
	
	print("assigned")
	print(fluid_points)
