extends Node3D

var arr2d = nd.zeros([4,4])

func _ready():
	
	print(arr2d)
	
	arr2d.set(1, nd.range(1, -1), nd.range(1, -1))
	
	print(arr2d)
	
	print(nd.add(arr2d.get(nd.range(1, &":")), arr2d))
	
	var vec_arr = []
	vec_arr.resize(4)
	vec_arr.fill(Vector3.ZERO) 
