extends Node3D

@onready var MainCam = $MainCam
@onready var HighPres = $HighPressure
@onready var LowPres = $LowPressure

signal highpres_changed()
signal lowpres_changed()

var keymaps: Array[Array] = [
	['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
	['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';'],
	['Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', 'SLASH']
	]
	
var state_array: Array
var index
var current_state
var global_pos

var x_pos: float = 0.0
var z_pos: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_array = [HighPres, LowPres]
	index = 0
	current_state = state_array[index]
	highpres_changed.connect(_on_highpres_received)
	lowpres_changed.connect(_on_lowpres_received)

func _input(event): # changing pressure
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			if index == len(state_array) - 1:
				index = 0
				current_state = state_array[index]
			else:
				index += 1
				current_state = state_array[index]

		for row in keymaps: # runs 3x - per row
			x_pos = 0.0
			z_pos = 0.0
			for input in row:
				if !event.is_action_pressed(input):
					pass
				elif event.is_action_pressed(input):
					x_pos = float(row.find(input)) / 10 * 10 - 4.5
					z_pos = float(keymaps.find(row)) / 10 * 5
					global_pos = Vector3(x_pos, 0, z_pos)
					current_state.global_position = global_pos
					if current_state == HighPres:
						highpres_changed.emit()
					else:
						lowpres_changed.emit()
					#print(x_pos, z_pos)
				else:
					print("error with keymaps")
	return global_pos
					
func _on_highpres_received():
	print("high_pres", global_pos)

func _on_lowpres_received():
	print("low_pres", global_pos)

func _process(delta: float) -> void:
	var cam_basis = MainCam.global_transform.basis
	
