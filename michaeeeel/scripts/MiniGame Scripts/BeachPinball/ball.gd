class_name PinBall
extends RigidBody2D

signal spawn_pinball

const INITIAL_IMPULSE = 100
const MAX_IMPULSE = 1500
var impulse = INITIAL_IMPULSE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
