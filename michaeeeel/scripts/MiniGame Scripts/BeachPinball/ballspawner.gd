class_name  BallSpawner
extends Node2D


const  MAX_BALLS : int = 4
var balls_used : int = 1
const BALL  = preload("uid://dnrg4epwg0k4b")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_Next_ball()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_Next_ball ():
	var ball : PinBall = BALL.instantiate()
	ball.global_position = global_position
	ball.spawn_pinball.connect(spawn_Next_ball)
	get_parent().add_child.call_deferred(ball)
