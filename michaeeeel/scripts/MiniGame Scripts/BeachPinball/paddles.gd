class_name  Paddles
extends Node2D

@onready var paddleleft: Paddle = $paddleleft

@onready var paddleright: Paddle = $paddleright


func _input(event: InputEvent) -> void:
	if  event is InputEventMouseButton :
		if   event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				paddleleft.flipped = true
				print("flipping")
			else:
				paddleleft.flipped = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				paddleright.flipped = true
			else:
				paddleright.flipped = false
