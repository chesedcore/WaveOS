class_name PinBall
extends RigidBody2D

signal spawn_pinball
signal score_points
const INITIAL_IMPULSE = 100
const MAX_IMPULSE = 1500
var impulse = INITIAL_IMPULSE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("jump_launch"):
		impulse += 500 * delta
		impulse = clamp(impulse ,INITIAL_IMPULSE,MAX_IMPULSE)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	spawn_pinball.emit()
	queue_free()

func _input(event: InputEvent) -> void:
	if freeze == true:
		if event.is_action_released("jump_launch"):
			freeze = false
			apply_central_impulse(Vector2.UP * impulse)


func _on_body_entered(body: Node) -> void:
	if body is Bumper:
		score_points.emit(500)
		var push_dir =Vector2.ZERO
		if body.dir =="right":
			push_dir = Vector2.UP +Vector2.LEFT
		elif body.dir == "left":
			push_dir =  Vector2.UP +  Vector2.RIGHT
		apply_central_impulse(push_dir *550)
	if body is Peg:
		score_points.emit(100)
