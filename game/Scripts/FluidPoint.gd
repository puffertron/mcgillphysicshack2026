class_name FluidPoint
extends Node3D
static var scene = load("res://fluid_point.tscn") 
@onready var visualizer = $Visualizer


var domain

var grid_position :Vector3i
var pressure : float
var density  : float
var temperature  : float
var velocity : Vector3
var acceleration :  Vector3
var viscosity : float

func setup(grid_pos, pos):
	grid_position = grid_pos
	position = pos

func update(delta):
	pass
	


	

	
	
func process(delta):
	visualizer.material.set_shader_parameter("pressure_vis", pressure)
	visualizer.material.set_shader_parameter("temperature_vis", temperature)
	
