extends Node3D

@onready var Seed = $Seed1

var speed = randf_range(5, 50)
var value = randf_range(-1, 1)
var direction: Variant = Vector3(value, value, value).normalized()
var speed_var_rate = 0.5
var direction_var_rate = 0.5

# randomize movement of seed
# find global position of seed, convert to grid position, identify pressure within that cell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var val1 = randf_range(0, get_viewport().size.x)
	var val2 = randf_range(0, get_viewport().size.y)
	var val3 = randf_range(0, get_viewport().size.z)
	position = Vector3(val1, val2, val3)

func _physics_process(delta: float) -> void:
	randomize_speed_and_direction()
	position += direction * speed * delta

func randomize_speed_and_direction():
	if randf() < speed_var_rate: # randf() is from 0 to 1
		speed = randf_range(5,50)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
