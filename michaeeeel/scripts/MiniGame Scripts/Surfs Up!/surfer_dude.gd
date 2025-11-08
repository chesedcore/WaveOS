class_name SurferPlayer
extends Area2D
@onready var ray_down: RayCast2D = $RayDown
@onready var ray_up: RayCast2D = $RayUp


@export var grav := 400
@export var verticle_strength := 350

var surfing: bool = false


func _process(delta: float) -> void:
	if !surfing and !ray_down.is_colliding():
		position.y += grav * delta             
	elif surfing and !ray_up.is_colliding():
		position.y += -verticle_strength * delta
	surf()

func surf():
	if Input.is_action_just_pressed("ui_accept"):
		surfing = true
	elif Input.is_action_just_released("ui_accept"):
		surfing = false
