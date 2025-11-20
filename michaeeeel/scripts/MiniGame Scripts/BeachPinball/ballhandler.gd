class_name  BallHandler
extends Node2D

signal  updatescore

const  MAX_BALLS : int = 5
var balls_used : int = 0
const BALL  = preload("uid://dnrg4epwg0k4b")
@onready var ball_count: RichTextLabel = $"../Sidebar/toppanel/VBoxContainer/BallCount"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_Next_ball()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_Next_ball ():
	if balls_used != MAX_BALLS:
		var ball : PinBall = BALL.instantiate()
		ball.global_position = global_position
		ball.spawn_pinball.connect(spawn_Next_ball)
		ball.score_points.connect(on_points)
		get_parent().add_child.call_deferred(ball)
		balls_used +=1
		ball_count.text = "BALLS LEFT : " + str( MAX_BALLS - balls_used)


func on_points( points :int):
	updatescore.emit(points)
