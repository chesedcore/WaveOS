class_name BreakerPlayer
extends Area2D

@onready var paddle_hit: Area2D = $PaddleHit
@onready var paddle_col: CollisionShape2D = $PaddleHit/CollisionShape2D
@onready var cooldown_timer: Timer = $CooldownTimer

var speed := 350
var direction := 0.0
var collided_with_wall := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			if paddle_col.disabled and cooldown_timer.time_left <= 0:
				hit_ball()
				print("HYEHYAHH")
	
	direction = Input.get_axis("key_left", "key_right")
	
func _process(delta: float) -> void:
	var hit_left = $RayL.is_colliding()
	var hit_right = $RayR.is_colliding()
	
	if (direction < 0 and hit_left) or (direction > 0 and hit_right):
		collided_with_wall = true
	else:
		collided_with_wall = false

	if !collided_with_wall:
		position.x += direction * speed * delta

func hit_ball():
	paddle_col.disabled = false
	await get_tree().create_timer(0.08).timeout
	paddle_col.disabled = true
	cooldown_timer.start(0.2)
