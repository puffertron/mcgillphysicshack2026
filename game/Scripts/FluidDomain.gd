extends Node3D
class_name FluidDomain

@export var fluid_point_scene: PackedScene
var fluid_points
@export var field_size: Vector3i = Vector3i(10,10,10) 
@export var cell_size: float = 1.0

#creates a new field based on field size on ready
func _ready():
	generate_field(field_size,cell_size)

	
func _process(delta):
	pass

## Generates a standard template grid for neighbors along all orthogonal coordinates. (Neighbor grid without diagonals)
func ortho_neighbor_grid() -> Array[Vector3i]:
	var neighbors: Array[Vector3i] = []
	
	for x in range(3):
		var point = Vector3i(-1+x, 0, 0)
		if point != Vector3i.ZERO:
			neighbors.append(point)
				
	for y in range(3):
		var point = Vector3i(0, -1+y, 0)
		if point != Vector3i.ZERO:
			neighbors.append(point)	
				
	for z in range(3):
		var point = Vector3i(0, 0, -1+z)
		if point != Vector3i.ZERO:
			neighbors.append(point)
			
	return neighbors
				
## returns an array of neighbors from a FluidPoint in along the X, Y and Z axes (No diagonals).
## array format is -X, +X, -Y, +Y, -Z, +Z
func get_orthogonal_neighbors(point: FluidPoint) -> Array[FluidPoint]:
	var check_pos: Vector3i = point.grid_position
	var neighbor_pos = ortho_neighbor_grid()
	var neighbors: Array[FluidPoint] =[]
	for p in neighbor_pos:
		#var neighbor = fluid_points[check_pos.x + p.x][check_pos.y + p.y][check_pos.z + p.z]
		var neighbor = get_point_at_pos(check_pos + p)
		neighbors.append(neighbor)
		
	return neighbors

## Sets pressure of a cell
func set_pressure(point: FluidPoint, pressure: float):
	pass

func global_pos_to_grid_pos(global_pos: Vector3) -> Vector3i:
	var localpos = to_local(global_pos)
	var grid_pos = Vector3i(round(localpos.x),round(localpos.y),round(localpos.z))
	return grid_pos

## Given a grid coordinate, returns the fluid simulation cell at that point
func get_point_at_pos(pos: Vector3) -> FluidPoint:
	var rounded_pos = Vector3i(round(pos.x), round(pos.y), round(pos.z))
	if pos.x >= 0 and pos.y >= 0 and pos.z >= 0 and pos.x < field_size.x and pos.y < field_size.y  and pos.z < field_size.z :
		return fluid_points[pos.x][pos.y][pos.z]	
	else:
		return null

## Creates a field of points based on size and cell size
func generate_field(size: Vector3i, cell_size: float):
	#fluid_points = size.z*[size.y*[size.x*[null]]]
	var z_array: Array[FluidPoint] = []
	z_array.resize(size.z)
	
	var y_array: Array[Array] = []
	y_array.resize(size.y)
	y_array.fill(z_array.duplicate_deep())
	
	var x_array: Array[Array] = []
	x_array.resize(size.x)
	x_array.fill(y_array.duplicate_deep())
	
	fluid_points = x_array.duplicate_deep()
	for x in range(size.x):
		for y in range(size.y):
			for z in range (size.z):
				var new_point = fluid_point_scene.instantiate()
				new_point.call("setup", Vector3i(x,y,z), Vector3(x,y,z)*cell_size)
				new_point.domain = self
				add_child(new_point)
				fluid_points[x][y][z] = new_point
