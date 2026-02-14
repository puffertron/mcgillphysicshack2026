extends Node3D

@onready var MainCam = get_parent().get_node("MainCam")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cam_basis = MainCam.global_transform.basis
	
	if Input.is_key_pressed(KEY_Q):
		print("Q pressed.")
