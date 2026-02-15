extends Node3D

var rd := RenderingServer.create_local_rendering_device()

var shader_file := load("res://Shaders/Compute/compute_example.glsl")
var shader_spirv : RDShaderSPIRV = shader_file.get_spirv()
var shader := rd.shader_create_from_spirv(shader_spirv)

func prepare_simulation_data(state: Array[FluidPoint]):
	var shader_params = []
	var pressure_in = PackedFloat32Array()
	for point in state:
		pressure_in.append(point.pressure)
		
	
	shader_params.append(pressure_in)
	
	return shader_params

func send_simulation_data(shader_params):
	var input := PackedFloat32Array([1,2,3,4,5,6,7,8,9,10])
	var input_bytes := input.to_byte_array()
	
	
	var buffer := rd.storage_buffer_create(input_bytes.size(), input_bytes)
	var uniform = RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform.binding = 0
	uniform.add_id(buffer)
	var uniform_set = rd.uniform_set_create([uniform], shader, 0)
	
	var pipeline = rd.compute_pipeline_create(shader)
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, 5, 1, 1)
	rd.compute_list_end()
	
	rd.submit()
	rd.sync()
	
		# Read back the data from the buffer
	var output_bytes := rd.buffer_get_data(buffer)
	var output := output_bytes.to_float32_array()
	print("Input: ", input)
	print("Output: ", output)
	
	rd.free_rid(buffer)
	rd.free_rid(pipeline)
	rd.free_rid(uniform_set)
	
func _ready():	
	pass
	
	
	
	
