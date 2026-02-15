extends Node3D

var seed = preload("res://Main/dandelions.tscn")
@onready var fluid_domain = $FluidDomain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1, 10):
		spawn()
		i += 1

func spawn():
	var instance = seed.instantiate()
	instance.position = Vector3(0, 0, 0)
	instance.fluid_domain = fluid_domain
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
