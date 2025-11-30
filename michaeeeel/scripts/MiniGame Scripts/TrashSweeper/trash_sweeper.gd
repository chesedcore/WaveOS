extends Minigame

const ROWS :int = 16
const COLS: int = 16
const CELL = preload("uid://c5qmmupokoihw")
const  MAX_MINES = 40
var mines_left = MAX_MINES
var flags_left = MAX_MINES
var grid = []
@onready var gameovermsg: RichTextLabel = $Gamearea/gameovermsg
@onready var healthcontainer: HBoxContainer = $Gamearea/uibackground/HBoxContainer/icon/ColorRect/healthcontainer

var  hp = 3
var gameend = false
@onready var grid_container: GridContainer = $Gamearea/boardbackground/MarginContainer/GridContainer
var first_move = true
@onready var trashlabel: RichTextLabel = $Gamearea/uibackground/HBoxContainer/TrashCount/trashlabel

var time = 0
@onready var timelabel: RichTextLabel = $Gamearea/uibackground/HBoxContainer/Timer/timelabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gane_setup()

func gane_setup():
	mines_left = MAX_MINES
	flags_left = MAX_MINES
	trashlabel.text = str(mines_left)
	
	hp = 3
	for i in range(hp):
		healthcontainer.get_children()[i].visible = true
	time = 0
	trashlabel.text =str(mines_left)
	grid.resize(0)
	await setupGrid()
	place_trash()


func setupGrid():
	grid.resize(ROWS) 
	for row in range(ROWS):
		grid[row] = [] 
		grid[row].resize(COLS) 
		for col in range(COLS):
			var new_cell :Cell =CELL.instantiate()
			grid_container.add_child(new_cell)
			grid[row][col] = new_cell
			new_cell.col =col
			new_cell.row = row 
			new_cell.pressed.connect(on_cell_pressed)
			new_cell.marked.connect(on_marked)
			new_cell.unmarked.connect(on_unmarked)
			
			
func place_trash():
	var mines = 0
	while mines != MAX_MINES:
		var col = randi_range(0,COLS-1)
		var row = randi_range(0,ROWS-1)
		if !grid[row][col].is_trash :
			grid[row][col].is_trash = true
			mines+=1


func on_cell_pressed(row:int,col:int,is_trash:bool):
	var cell :Cell = grid[row][col]
	if is_trash:
		if first_move:
			first_move = false
			cell.is_trash = false
			while true:
				var new_col = randi_range(0,COLS-1)
				var new_row = randi_range(0,ROWS-1)
				if !grid[new_row][new_col].is_trash :
					grid[new_row][new_col].is_trash = true
					break
			check_for_trash(row,col)
		else:
			cell.color =  Color( 0,0,0,)
			hp-=1
			healthcontainer.get_children()[hp].visible = false
			mines_left-=1
			flags_left-=1
			trashlabel.text = str(flags_left)
		cell.cleared = true
		if hp == 0 :
			lose_game()
	else:
		cell.color =  Color(243,206,0)
		first_move = false
		check_for_trash(row,col)
	

func check_for_trash(row:int,col:int):
	var adjacent_trash = 0
	var cell : Cell = grid[row][col]
	if(col-1 >=0):
		if grid[row][col-1].is_trash:
			adjacent_trash +=1
	if(row-1 >=0):
		if grid[row-1][col].is_trash:
			adjacent_trash +=1
	if(col+1 <=15):
		if grid[row][col+1].is_trash:
			adjacent_trash +=1
	if(row+1 <=15):
		if grid[row+1][col].is_trash:
			adjacent_trash +=1
	if ((col-1 >=0) and (row-1 >=0)):
		if grid[row-1][col-1].is_trash:
			adjacent_trash +=1
	if ((col+1 <=15) and (row-1 >=0)):
		if grid[row-1][col+1].is_trash:
			adjacent_trash +=1
	if ((col-1 >=0) and (row+1 <=15)):
		if grid[row+1][col-1].is_trash:
			adjacent_trash +=1
	if ((col+1 <=15) and (row+1 <=15)):
		if grid[row+1][col+1].is_trash:
			adjacent_trash +=1
	cell.adjacent_trash = adjacent_trash
	cell.color =  Color(243,206,0)
	cell.cleared = true
	cell.trashcounter.text = str(adjacent_trash)
	if adjacent_trash == 0:
		if(col-1 >=0):
			if !grid[row][col-1].cleared:
				check_for_trash(row,col-1)
		if(row-1 >=0):
			if !grid[row-1][col].cleared:
				check_for_trash(row-1,col)
		if(col+1 <=15):
			if !grid[row][col+1].cleared:
				check_for_trash(row,col+1)
		if(row+1 <=15):
			if !grid[row+1][col].cleared:
				check_for_trash(row+1,col)
		if ((col-1 >=0) and (row-1 >=0)):
			if !grid[row-1][col-1].cleared :
				check_for_trash(row-1,col-1)
		if ((col+1 <=15) and (row-1 >=0)):
			if !grid[row-1][col+1].cleared :
				check_for_trash(row-1,col+1)
		if ((col-1 >=0) and (row+1 <=15)):
			if !grid[row+1][col-1].cleared :
				check_for_trash(row+1,col-1)
		if ((col+1 <=15) and (row+1 <=15)):
			if !grid[row+1][col+1].cleared :
				check_for_trash(row+1,col+1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !first_move:
		time+= delta
		var minimum :int = time / 60
		var sec :int = int(time) % 60
		timelabel.text = str(minimum) +":"+str(sec)

func on_marked(has_trash:bool):
	if has_trash:
		mines_left -=1
	flags_left -=1
	trashlabel.text = str(flags_left)
	if flags_left == 0 and mines_left == 0:
		wingame()
	
func on_unmarked(has_trash : bool):
	flags_left+=1
	if has_trash:
		mines_left+=1
	trashlabel.text = str(flags_left)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump_launch") and gameend == true:
		gameend = false
		gameovermsg.visible = false
		await delete_all_cells()
		gane_setup()

func lose_game():
	clearAllCells()
	gameovermsg.text = "GAME OVER \nPress Space to play again"
	gameend = true
	gameovermsg.visible = true
	first_move = true
	lost_minigame.emit()

func clearAllCells():
	for row in range(ROWS): 
		for col in range(COLS):
			grid[row][col].cleared = true
			if grid[row][col].is_trash == true:
				grid[row][col].color =  Color( 0,0,0,)
			
func delete_all_cells():
	for row in range(ROWS): 
		for col in range(COLS):
			
			grid[row][col].queue_free()


func wingame():
	gameend = true
	gameovermsg.visible = true
	won_minigame.emit()
