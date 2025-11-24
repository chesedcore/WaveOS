class_name SnakeHeaed extends Node2D

var head := SnakeSegmant.new()
var consecutive_blacksegmants=0
var consecutive_whitesegmants=0
var segmants  := [] as Array[SnakeSegmant]
var length := 1
var cur_direction: Vector2 = Vector2.RIGHT
var nexrdirection: Vector2 = Vector2.RIGHT
var tweem_move :Tween
signal hit(lenght :int)
func _process(delta: float) -> void:
	queue_redraw()


func _ready() -> void:
	hit.connect(_on_hit)
	head.size = Vector2(32,32)
	head.color = Color.GRAY
	segmants.push_front(head)
	tweem_move = create_tween().set_loops()
	tweem_move.tween_callback(move).set_delay(.1)

	
func _draw() -> void:
	for segmant in segmants:
		draw_rect(segmant.get_rect(),segmant.color)

func reset():
	length = 1
	segmants.clear()
	segmants.push_front(head)
	tweem_move = create_tween().set_loops()
	tweem_move.tween_callback(move).set_delay(.1)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("key_left") and cur_direction != Vector2.RIGHT:
		nexrdirection = Vector2.LEFT
	if Input.is_action_just_pressed("key_right") and cur_direction != Vector2.LEFT:
		nexrdirection = Vector2.RIGHT
	if Input.is_action_just_pressed("key_up") and cur_direction != Vector2.DOWN:
		nexrdirection = Vector2.UP
	if Input.is_action_just_pressed("key_down") and cur_direction != Vector2.UP:
		nexrdirection = Vector2.DOWN

		

func move():
	cur_direction = nexrdirection
	var next_pos =  head.curr_position + (cur_direction * head.size)
	next_pos.x = fposmod(next_pos.x,1152)
	next_pos.y = fposmod(next_pos.y,648)
	head.curr_position = next_pos
	for i in range(1,segmants.size()):
		segmants[i].curr_position = segmants[i-1].pre_position
		
	#checkcoll
	for i in range(1,segmants.size()):
		if head.get_rect().intersects(segmants[i].get_rect()):
			hit.emit(length)
			break

func grow():
	var segmant = SnakeSegmant.new()
	var last_segmant = segmants.back() as SnakeSegmant
	segmant.size = last_segmant.size
	segmant.curr_position = last_segmant.curr_position
	if consecutive_blacksegmants == 2:
		segmant.color = Color.WHITE
		consecutive_whitesegmants +=1
		if consecutive_whitesegmants == 2 :
			consecutive_blacksegmants = 0
	else:
		consecutive_blacksegmants +=1
		consecutive_whitesegmants = 0
		segmant.color= Color.BLACK
	segmants.push_back(segmant)
	length += 1

func _on_hit(length :int):
	tweem_move.kill()
	
	for seg in segmants:
		seg.go_to_prev_pos()
		
