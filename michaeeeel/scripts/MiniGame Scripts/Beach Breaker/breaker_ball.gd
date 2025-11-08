class_name BreakerBall
extends Node2D

@onready var player_center: BreakerPlayer = %BreakerPlayer
@onready var screen_center: Marker2D = %ScreenCenter


@onready var ray_down: RayCast2D = $RayDown

@onready var ray_up: RayCast2D = $RayUp

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_right_2: RayCast2D = $RayRight2
@onready var ray_right_3: RayCast2D = $RayRight3

@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_left_2: RayCast2D = $RayLeft2
@onready var ray_left_3: RayCast2D = $RayLeft3


var direction := Vector2.UP

var speed := 250

func get_direction() -> Vector2:
	if ray_up.is_colliding():
		direction.y = 1
	
	if ray_down.is_colliding():
		direction.y = -1
	
	if ray_left.is_colliding() or ray_left_2.is_colliding() or ray_left_3.is_colliding():
		direction.x = 1
	
	if ray_right.is_colliding() or ray_right_2.is_colliding() or ray_right_3.is_colliding():
		direction.x = -1
	
	return direction

func _process(delta: float) -> void:
	
	position += get_direction() * speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == player_center.paddle_hit:
		direction.y = -1
		
		if global_position < player_center.paddle_hit.global_position:
			direction.x = -1
		elif global_position > player_center.paddle_hit.global_position:
			direction.x = 1
	
	elif area is Octopus:
		area.queue_free()
