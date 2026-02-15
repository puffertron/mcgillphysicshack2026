extends Node3D
class_name FluidDomain

@export var fluid_point_scene: PackedScene
var fluid_points:Array[Array] #First element chooses x pos, second: y, third: z
@export var field_size: Vector3i = Vector3i(8,1,8) 
@export var cell_size: float = 1.0
@onready var field_controller:Node3D = get_parent().get_node("FieldController")

var sim_params 

@onready var points_anchor = $PointsAnchor

const INOUTLET_MAG = 1 #Amount of flow through inlet or outlet

var sim_params:Array

#creates a new field based on field size on ready
func _ready():
	generate_field(field_size,cell_size)
	center_domain()
	
	sim_params = generateFieldFast(field_size,cell_size)
	print(nd_diffuse(1, sim_params[0], sim_params[1], 0 , 0))

func _process(delta):
	# Set points at control_points to be at specific value
	for ctrl_point_in in field_controller.ctrl_points_in:
		var ctrl_point_in_pos = ctrl_point_in[0]
		var ctrl_point_in_dir = ctrl_point_in[1]
		sim_params[0][ctrl_point_in_pos.x][ctrl_point_in_pos.y][ctrl_point_in_pos.z].velocity = ctrl_point_in_dir*INOUTLET_MAG
		
		#OLD WAY when points were in charge of their own state
		#if get_point_at_pos(ctrl_point_in_pos):
			#get_point_at_pos(ctrl_point_in_pos).velocity = ctrl_point_in_dir*INOUTLET_MAG
			#get_point_at_pos(ctrl_point_in_pos).highlight_on()
	for ctrl_point_out in field_controller.ctrl_points_out:
		var ctrl_point_out_pos = ctrl_point_out[0]
		var ctrl_point_out_dir = ctrl_point_out[1]
		sim_params[0][ctrl_point_out_pos.x][ctrl_point_out_pos.y][ctrl_point_out_pos.z].velocity = ctrl_point_out_dir*INOUTLET_MAG
		
		#OLD WAY when points were in charge of their own state
		#if get_point_at_pos(ctrl_point_out_pos):
			#get_point_at_pos(ctrl_point_out_pos).velocity = ctrl_point_out_dir*INOUTLET_MAG
	
	#KIDANE!!!!!!! we are adding the fluidPoints updating stuff here
	#TODO - Calculate the next steps using sim_params
	
	#Tell the fluid_points to update
	update_all_points()
	
	
	
	
	#OLD WAY when points were in charge of updating their own state
	#for xArray in fluid_points:
		#for yArray in xArray:
			#for fluid_point:FluidPoint in yArray:
				##Runs once per fluid_point
				#fluid_point.update(delta)
				#
	#for xArray in fluid_points:
		#for yArray in xArray:
			#for fluid_point:FluidPoint in yArray:
				##Runs once per fluid_point
				#fluid_point.apply()

## This gets called every loop to update the fluidPoints with simParams
func update_all_points():
	for x in range(len(sim_params[0])):
		for y in range(len(sim_params[0][0])):
			for z in range(len(sim_params[0][0][0])):
				# Go over every point
#				Note, this structure is awful. We should rewrite this
				fluid_points[x][y][z].density = sim_params[2][x][y][z]
				fluid_points[x][y][z].velocity = sim_params[0][x][y][z]


func center_domain():
	var actual_size = field_size * cell_size
	points_anchor.translate(-actual_size/2)
	
	
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
	point.pressure = pressure

## input 0 to 1, and should map from 0 to size - 1
func fraction_to_grid_pos(pos: Vector3):
	var grid_pos = Vector3i(round(pos.x * (field_size.x - 1)),round(pos.y * (field_size.y - 1)),round(pos.z * (field_size.z - 1)))
	return grid_pos

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
				points_anchor.add_child(new_point)
				fluid_points[x][y][z] = new_point

func generateFieldFast(size: Vector3i, cell_size: float):
	var real_size = size + Vector3i(2,0,2)
	
	var velocity_field_z = []
	velocity_field_z.resize(real_size.z)
	velocity_field_z.fill(Vector2.ZERO)
	
	var velocity_field_x = []
	velocity_field_x.resize(real_size.x)
	velocity_field_x.fill(velocity_field_z.duplicate_deep())
	
	var velocity_field = velocity_field_x.duplicate_deep()
	var velocity_field_delta = velocity_field.duplicate_deep()
	
	var density_field_z = []
	density_field_z.resize(real_size.z)
	density_field_z.fill(0)
	
	var density_field_x = []
	density_field_x.resize(real_size.x)
	density_field_x.fill(velocity_field_z.duplicate_deep())
	
	var density_field = density_field_x.duplicate_deep()	
	var density_field_delta = density_field.duplicate_deep()
	
	velocity_field = nd.array(velocity_field)
	velocity_field_delta = nd.array(velocity_field_delta)
	density_field = nd.array(density_field)
	density_field_delta = nd.array(density_field_delta)
	
	return [velocity_field, velocity_field_delta, density_field, density_field_delta]
	
	
	
func simulate_da_thing(b, value:Array, delta_value, diffusion, delta):
	nd_diffuse(b, value, delta_value, diffusion, delta)
	
	

func nd_diffuse(b, value:Array, delta_value, diffusion, delta):
	var a = delta * diffusion * field_size.x * field_size.z
	
	var v = nd.array(value)
	var v0 = nd.array(delta_value)
	
	for k in range(20):
		#value to be set,       indexes
		v.set(
			v0.get(nd.range(1,-1), nd.range(1,-1)) + a * 
			v.get(nd.range(0,-2), nd.range(1,-1)) + v.get(nd.range(2, &":"), nd.range(1,-1)) +
			v.get(nd.range(1,-1), nd.range(0,-2)) + v.get(nd.range(1,-1), nd.range(2, &":")) 
			/ (1 + 4 *  a),
			nd.range(1,-1), nd.range(1,-1) )
		
		self.set_boundary(b, v)

func set_boundary(b, x):
	if b ==1: #horizontal (x)
		#set  | value to be set         | indexes to set at
		x.set(-x.get(1, nd.range(1, -1)), 0, nd.range(1, -1))
		x.set(-x.get(-2, nd.range(1, -1)),  -1, nd.range(1, -1))
	else:
		#set  | value to be set         | indexes to set at
		x.set(x.get(1, nd.range(1, -1)), 0, nd.range(1, -1))
		x.set(x.get(-2, nd.range(1, -1)), -1, nd.range(1, -1))
	if b == 2:
		#set  | value to be set         | indexes to set at
		x.set(-x.get(nd.range(1, -1), 1), nd.range(1, -1), 0)
		x.set(-x.get(nd.range(1, -1), -2), nd.range(1, -1), -1)
	else:
		#set  | value to be set         | indexes to set at
		x.set(x.get(nd.range(1, -1), 1), nd.range(1, -1), 0)
		x.set(x.get(nd.range(1, -1), -2), nd.range(1, -1), -1)
	
	x.set( 0.5 * x.get(1,0) + x.get(0, 1), nd.range(0,0))
	x.set( 0.5 * x.get(1,-1) + x.get(0, -2), nd.range(0,-1))
	x.set( 0.5 * x.get(-2,0) + x.get(-1, 1), nd.range(-1,0))
	x.set( 0.5 * x.get(-2,-1) + x.get(-1, -2), nd.range(-1,-1))
	






		
	

	
