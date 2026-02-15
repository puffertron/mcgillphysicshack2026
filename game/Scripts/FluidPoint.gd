class_name FluidPoint
extends Node3D
static var scene = load("res://fluid_point.tscn") 
@onready var visualizer = $Visualizer
@onready var highlight = $Highlight



var domain: FluidDomain

var highlighted : bool = false
var grid_position :Vector3i
var pressure : float
var pressure_dif: float #Amount of pressure to change next frame
var density  : float
var temperature  : float
var velocity : Vector3
var velocity_next : Vector3
var acceleration :  Vector3
var viscosity : float

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
	# Get neighbors
	var neighbors: Array[FluidPoint] = domain.get_orthogonal_neighbors(self)
	
	const flow_per_pressure = 1 #arbitrary constant representing how quick flow happens per change in pressure
	# Calc pressure difference between each neighbor
	var difference_pressure
	var difference_pressures = []
	var flows = []
	var netFlow = 0
	for i in range(6):
		if neighbors[i] == null:
			pass
		else:
			var incoming_pressure = neighbors[i].pressure
			difference_pressure = pressure - incoming_pressure
			difference_pressures.append(difference_pressure)
		
			# Calc flow between each neighbor
			var flow = difference_pressure*delta*flow_per_pressure
			flows.append(flow)
			
			# Sum total flow to know change for next state
			netFlow += flow
			var v_x = (difference_pressures[0] + difference_pressures[1]) / 2
			var v_y = (difference_pressures[2] + difference_pressures[3]) / 2
			var v_z = (difference_pressures[4] + difference_pressures[5]) / 2
			
			velocity_next = Vector3(v_x, v_y, v_z)
		
	#Change in pressure for next state is based on total 'flow'
	pressure_dif = netFlow 

## Applies changes figured out from self.update()
func apply():
	pressure = pressure + pressure_dif
	velocity = velocity_next
	

	

	
	
func process(delta):
	visualizer.material.set_shader_parameter("pressure_vis", pressure)
	visualizer.material.set_shader_parameter("temperature_vis", temperature)
	
