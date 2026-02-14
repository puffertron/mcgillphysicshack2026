extends Node3D

@onready var MainCam = $MainCam
@onready var HighPres = $HighPressure
@onready var LowPres = $LowPressure

var keymaps: Array[Array] = [
	[KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T, KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P],
	[KEY_A, KEY_S, KEY_D, KEY_F, KEY_G, KEY_H, KEY_J, KEY_K, KEY_L, KEY_SEMICOLON],
	[KEY_Z, KEY_X, KEY_C, KEY_V, KEY_B, KEY_N, KEY_M, KEY_COMMA, KEY_PERIOD, KEY_SLASH]
	]
	
var state_array: Array
var index
var current_state

var x_pos: float = 0.0
var z_pos: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_array = [HighPres, LowPres]
	index = 0
	current_state = state_array[index]

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
				if event.is_pressed and event.keycode != input:
					pass
				elif event.is_pressed and event.keycode == input:
					print(current_state)
					x_pos = float(row.find(input)) / 10 * 10 - 4.5
					print(x_pos)
					z_pos = float(keymaps.find(row)) / 10 * 5
					print(keymaps.find(row))
					current_state.global_position = Vector3(x_pos, 0, z_pos)
					print(x_pos, z_pos)
				else:
					print("error with keymaps")

func _process(delta: float) -> void:
	var cam_basis = MainCam.global_transform.basis
