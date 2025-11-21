class_name BeachBreaker
extends Minigame

@onready var spawn_timer: Timer = $SpawnTimer
@onready var path_2d: Path2D = $Path2D
@onready var octos_node: Node2D = $OctosNode


var spawn_delay_time := 1.5

var current_player: BreakerPlayer

var level_speed := 15


func _ready() -> void:
	current_player = %BreakerPlayer
	spawn_timer.start(spawn_delay_time)

func spawn_octo() -> void:
	var spawn_point = path_2d.curve.get_point_position(randi_range(0, (path_2d.curve.point_count - 1)))
	const OCTOS = preload("uid://cnacntis1qwrx")
	var octo_inst: Octopus = OCTOS.instantiate()
	octos_node.add_child(octo_inst)
	octo_inst.speed += level_speed
	if spawn_point != Vector2.ZERO:
		octo_inst.global_position = spawn_point


func _on_spawn_timer_timeout() -> void:
	spawn_octo()
	spawn_timer.start(spawn_delay_time)


func _on_lose_area_area_entered(area: Area2D) -> void:
	if area is not Octopus:
		area.queue_free()
		reset_ball()
	elif area is Octopus:
		print("you lose")
		

func reset_ball():
	const BREAKER_PLAYER = preload("uid://iy6s2au50nfs")
	var breaker_player_inst = BREAKER_PLAYER.instantiate()
	self.call_deferred("add_child", breaker_player_inst)
	breaker_player_inst.global_position = current_player.global_position
	current_player.queue_free()
	current_player = breaker_player_inst 
