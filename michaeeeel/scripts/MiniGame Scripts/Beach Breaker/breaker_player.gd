class_name BreakerPlayer
extends Area2D

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var breaker_ball: BreakerBall = $BreakerBall

var speed := 400
var direction := 0.0
var collided_with_wall := false

func _unhandled_input(_event: InputEvent) -> void:
	direction = Input.get_axis("key_left", "key_right")
	if Input.is_action_just_pressed("ui_accept") and !breaker_ball.deployed:
		breaker_ball.deploy_ball()

func _process(delta: float) -> void:
	var hit_left = $RayL.is_colliding()
	var hit_right = $RayR.is_colliding()
	
	if (direction < 0 and hit_left) or (direction > 0 and hit_right):
		collided_with_wall = true
	else:
		collided_with_wall = false

	if !collided_with_wall:
		position.x += direction * speed * delta
