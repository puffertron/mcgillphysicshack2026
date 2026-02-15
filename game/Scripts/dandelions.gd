extends Node3D

@onready var Seed = $Seed1
@export var fluid_domain: Node3D

var grid_pos: Vector3
var cell: Object
var speed = randf_range(0.25, 2)
var val = randf_range(-1, 1)
var val3 = randf_range(-1, 1)
var direction: Variant = Vector3(val, 0, val3).normalized()
var speed_var_rate = 0.5
var direction_var_rate = 0.01
var velocity: Variant = Vector3(1, 0, 1)

func _ready() -> void:
	#for i in range (1,10):
		#spawn()
		#i += 1
	position = Vector3(0, 0, 0)

func _physics_process(delta: float) -> void:
	randomize_speed_and_direction()
	position += ((direction * speed * delta) + velocity) / 2 * 0.1

func randomize_speed_and_direction():
	if randf() < speed_var_rate: # randf() is from 0 to 1
		speed = randf_range(0.25, 2)
	if randf() < direction_var_rate:
		val = randf_range(-1, 1)
		val3 = randf_range(-1, 1)
		direction = Vector3(val, 0, val3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	grid_pos = fluid_domain.global_pos_to_grid_pos(position)
	cell = fluid_domain.get_point_at_pos(grid_pos)
	print(position)
	#velocity = cell.velocity
	#print(velocity)
