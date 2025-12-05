class_name FloatyFuckMediaIcon extends Sprite2D

@export var fallback_rect_size := Vector2.ZERO

const MAX_ROT = 17.0  #degrees of tilt
const SMOOTHNESS = 8.0
const FLOAT_SPEED = 1.5  #how fast it idly floats

@onready var mat := material as ShaderMaterial
var target_x_rot := 0.0
var target_y_rot := 0.0
var hovering := false
var t := 0.0  #time accumulator

func _ready() -> void:
	set_process(true)
	set_process_input(true)

func _process(delta) -> void:
	t += delta

	if not hovering:
		#float idly (use an orbital motion to switch up the target x and y)
		target_x_rot = sin(t * FLOAT_SPEED) * MAX_ROT * 0.3
		target_y_rot = cos(t * FLOAT_SPEED) * MAX_ROT * 0.3

	#ease to target, good thing that this also eases when you leave the card
	#so it transitions back to floating smoothly
	mat.set_shader_parameter("x_rot", lerp(mat.get_shader_parameter("x_rot"), target_x_rot, delta * SMOOTHNESS))
	mat.set_shader_parameter("y_rot", lerp(mat.get_shader_parameter("y_rot"), target_y_rot, delta * SMOOTHNESS))
