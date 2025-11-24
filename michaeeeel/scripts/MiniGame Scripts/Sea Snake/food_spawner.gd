extends Node2D
var food := Food.new()
@onready var snake := %Snakehead as SnakeHeaed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_food()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if food.get_rect().intersects(snake.head.get_rect()):
		snake.grow()
		spawn_food()
	
func _draw() -> void:
	draw_rect(food.get_rect(),food.color)
	
	
func spawn_food():
	var is_on_occupied_position = true
	
	while is_on_occupied_position:
		var random_position =  Vector2()
		random_position.x = randi_range(0,1152 - 32)
		random_position.y = randi_range(0, 648 - 32)
		food.position = random_position.snapped(Vector2(32,32))
		for segmant in snake.segmants:
			if food.get_rect().intersects(segmant.get_rect()):
				is_on_occupied_position = true
				break
			else:
				is_on_occupied_position = false
