class_name Octopus
extends Area2D

var speed := 15.0


func _process(delta: float) -> void:
	position.y += speed * delta
