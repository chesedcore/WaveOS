class_name BreakerBall
extends Node2D

@onready var player_center: BreakerPlayer = $".."
var screen_center: Marker2D


@onready var ray_down: RayCast2D = $RayDown

@onready var ray_up: RayCast2D = $RayUp

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_right_2: RayCast2D = $RayRight2
@onready var ray_right_3: RayCast2D = $RayRight3

@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_left_2: RayCast2D = $RayLeft2
@onready var ray_left_3: RayCast2D = $RayLeft3


var direction := Vector2.UP

var speed := 300

var deployed := false

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
	if deployed:
		position += get_direction() * speed * delta
		
	
	
	if (ray_left_3.get_collider() is BreakerPlayer) or (ray_down.get_collider() is BreakerPlayer) \
	or (ray_right_3.get_collider() is BreakerPlayer):
		if player_center.global_position > global_position:
			direction.x = -1
		elif player_center.global_position < global_position:
			direction.x = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Octopus:
		area.queue_free()

func deploy_ball() -> void:
	deployed = true
	$Area2D.monitoring = true
	reparent($"../..")
