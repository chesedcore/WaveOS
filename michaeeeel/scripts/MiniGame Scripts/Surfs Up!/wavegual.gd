class_name Wavegual
extends Area2D

@export var speed := 100

var max_travel_distance := 1900
var traveled_distance := 0

func _process(delta: float) -> void:
	position.x += -speed * delta
