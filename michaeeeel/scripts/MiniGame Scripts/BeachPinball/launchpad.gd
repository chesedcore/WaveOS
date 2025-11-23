extends Area2D

@onready var timer: Timer = $Timer
var pinball : PinBall = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body is PinBall:
		pinball = body
		pinball.set_deferred("freeze",true)
		timer.start()


func _on_timer_timeout() -> void:
	var impulse = 1500
	pinball.freeze = false
	pinball.apply_central_impulse(Vector2.UP * impulse)
	call_deferred("queue_free")
	
