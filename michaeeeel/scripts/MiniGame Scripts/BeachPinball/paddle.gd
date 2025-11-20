class_name  Paddle
extends AnimatableBody2D



var flipped = false




@export var rest_angle = 0.0
@export var flip_angle = -90.0
var speed = 10

var current_angle = rest_angle

func _physics_process(delta):
	if flipped:
		current_angle = lerp(current_angle, flip_angle, speed*delta )
	else:
		current_angle = lerp(current_angle, rest_angle, speed*delta )
	rotation_degrees = current_angle
