extends Node3D


signal inlet_changed(position)
signal outlet_changed(position)

@export var domain: FluidDomain

#var keymaps: Array[Array] = [
	#['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
	#['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';'],
	#['Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', 'SLASH']
	#]
var keymaps: Array[Array] = [
	['Q', 'A', 'Z'],
	['P', ';', 'SLASH'],
	['W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O'],
	['X', 'C', 'V', 'B', 'N', 'M', ',', '.']
]

var ctrl_points_in: Array[Vector3] = []
var ctrl_points_out: Array[Vector3] = []
	
var state_array: Array
var index
var current_state
var global_pos

var x_pos: float = 0.0
var z_pos: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_array = [0, 1]
	index = 0
	current_state = state_array[index]
	inlet_changed.connect(_on_inlet_created)
	outlet_changed.connect(_on_outlet_created)


## space to switch pressures (starts at high), enter to clear all points
func _input(event): # changing pressure
	if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_SPACE:
			#if index == len(state_array) - 1:
				#index = 0
				#current_state = state_array[index]
			#else:
				#index += 1
				#current_state = state_array[index]

		if event.pressed and event.keycode == KEY_ENTER:
			ctrl_points_in = []
			ctrl_points_out = []

		for row in keymaps: # runs 3x - per row
			x_pos = 0.0
			z_pos = 0.0
			for input in row:
				if !event.is_action_pressed(input):
					pass
				elif event.is_action_pressed(input):
					var case = float(keymaps.find(row)) #figure out 0,1,2 or 3 to know what wall this is
					if case == 0 or case == 1:
						# First set x component to 0 or 10 based on left or right wall
					if case == 2 or case == 3:
						
						pass
					x_pos = float(row.find(input)) / 10
					z_pos = float(keymaps.find(row)) / 3
					var relative_ctrl_pos = Vector3(x_pos,0, z_pos)
					var domain_pos = domain.fraction_to_grid_pos(relative_ctrl_pos)
					#global_pos = Vector3(x_pos, 0, z_pos)
					global_pos = domain_pos
					#current_state.global_position = global_pos
					if current_state == 0:
						inlet_changed.emit(global_pos)
					elif current_state == 1:
						outlet_changed.emit(global_pos)
					#print(x_pos, z_pos)
				else:
					print("error with keymaps")
	return global_pos
					
func _on_inlet_created(global_pos):
	ctrl_points_in.append(global_pos)
	print(ctrl_points_in)

func _on_outlet_created(global_pos):
	ctrl_points_out.append(global_pos)
	print(ctrl_points_out)

func _process(delta: float) -> void:
	pass
	
