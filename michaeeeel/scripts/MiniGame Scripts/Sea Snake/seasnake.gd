extends Minigame

const GRID_SIZE := Vector2(1152,648)
const CELLS_SIZE := Vector2(32,32)
@onready var gameovermsg: RichTextLabel = $gameovermsg
@onready var snakehead: SnakeHeaed = %Snakehead
var gameover = false
const CELLS_AMOUNT := Vector2(GRID_SIZE.x / CELLS_SIZE.x, GRID_SIZE.y / CELLS_SIZE.y)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#
#func _draw() -> void:
	#draw_rect(Rect2(0,0, GRID_SIZE.x,GRID_SIZE.y),Color.NAVY_BLUE)
	#for i in CELLS_AMOUNT.x:
		#var from := Vector2(i * CELLS_SIZE.x,0)
		#var to := Vector2(from.x , GRID_SIZE.y)
		#draw_line(from,to,Color.GRAY)
	#for i in CELLS_AMOUNT.y:
		#var from := Vector2(0, i * CELLS_SIZE.y)
		#var to := Vector2(GRID_SIZE.x , from.y) 
		#draw_line(from,to,Color.GRAY)


func  _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and gameover:
		snakehead.reset()
		gameover = false
		gameovermsg.visible = false


func _on_snakehead_hit(lenght: int) -> void:
	gameover = true
	gameovermsg.text = "GAME OVER\nMAX LENGTH : "+str(lenght) +"\n PRESS ENTER TO PLAY AGAIN"
	gameovermsg.visible = true
