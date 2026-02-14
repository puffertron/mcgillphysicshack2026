extends Node3D

@export var fluid_point_scene: PackedScene
var fluid_points

func _ready():
	generate_field(Vector3i(10,10,10), 0.5)
	
func _process(delta):
	pass

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
				add_child(new_point)
				fluid_points[x][y][z] = new_point
	
	print("assigned")
	print(fluid_points)
