class_name FluidPoint
extends Node3D
static var scene = load("res://fluid_point.tscn") 
@onready var visualizer = $Visualizer
@onready var highlight = $Highlight
@onready var label = $Visualizer/Label3D

var counter = 0

var feq = FluidEquations.new()
var domain: FluidDomain


var highlighted : bool = false
var grid_position :Vector3i
var pressure : float = 5.0
var pressure_dif: float #Amount of pressure to change next frame
var density  : float
var temperature  : float
var velocity : Vector3
var velocity_dif : Vector3
var velocity_next : Vector3
var acceleration :  Vector3
var viscosity : float

var old_basis

func _ready():
	highlight.visible = false

func highlight_on():
	highlighted = true
	highlight.visible = true
	
func highlight_off():
	highlighted = false
	highlight.visible = false


func setup(grid_pos, pos):
	grid_position = grid_pos
	position = pos

## Figures out changes for point in next time step (currently just updates pressure_dif)
func update(delta):
	var results = feq.ciaranPropogation(domain, pressure, self, delta)
	#var results = feq.nvidaSolver(self, domain, delta)
	pressure_dif = results[0]
	velocity_dif = results[1]
	
func apply():
	pressure = pressure + pressure_dif
	velocity += velocity_dif

	

	

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func _process(delta):
	label.text = str(round_to_dec(pressure, 3))
	visualizer.material.set_shader_parameter("pressure_vis", float(pressure))
	visualizer.material.set_shader_parameter("temperature_vis", temperature)
	
	visualizer.look_at(global_transform.origin + velocity, Vector3.UP)

		#counter += delta

	
