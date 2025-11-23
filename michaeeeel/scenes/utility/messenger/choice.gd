class_name Choice extends ChatItem

@export var label: RichTextLabel

var current_id: String = ""
var next_id: String = ""

signal clicked(choice: Choice)

##forward func
func set_text(text: String) -> void: label.set_text(text)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)

static func from(
	text: String, 
	curr_id: String, 
	nxt_id: String
) -> Choice:
	var choice: Choice = load("res://scenes/utility/messenger/choice.tscn").instantiate()
	choice.current_id = curr_id
	choice.next_id = nxt_id
	choice.set_text.call_deferred(text)
	return choice
