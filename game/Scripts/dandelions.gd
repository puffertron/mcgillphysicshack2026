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
var velocity: Variant = Vector3(0, 0, 0)

# randomize movement of seed
# find global position of seed, convert to grid position, identify pressure within that cell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Seed.position = Vector3(0, 0, 0)

func _physics_process(delta: float) -> void:
	randomize_speed_and_direction()
	Seed.position += ((direction * speed * delta) + velocity) / 2

func randomize_speed_and_direction():
	if randf() < speed_var_rate: # randf() is from 0 to 1
		speed = randf_range(0.25, 2)
	if randf() < direction_var_rate:
		val = randf_range(-1, 1)
		val3 = randf_range(-1, 1)
		direction = Vector3(val, 0, val3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	grid_pos = fluid_domain.global_pos_to_grid_pos(Seed.position)
	cell = fluid_domain.get_point_at_pos(grid_pos)
	velocity = cell.velocity
	print(velocity)
