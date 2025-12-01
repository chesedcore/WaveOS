class_name  Cell
extends ColorRect
var row :int
var col: int
var is_trash : bool = false
var adjacent_trash :int = 0
var cleared :bool = false
var has_mouse = false
@onready var trashcounter: RichTextLabel = $trashcounter

signal pressed
signal marked 
signal unmarked
@onready var icon: TextureRect = $icon

const GOALMARKER = preload("res://assets/MiniGame Assets/TrashSweeper/goalmarker.png")







func _on_press_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and !cleared:
			pressed.emit(row,col,is_trash)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if !cleared:
				cleared = true
				icon.visible = true
				marked.emit(is_trash)
			else:
				cleared = false
				icon.visible = false
				unmarked.emit(is_trash)
