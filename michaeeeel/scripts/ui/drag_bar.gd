class_name DragBar extends HBoxContainer

signal drag_started
signal drag_ended

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: drag_started.emit()
			else: drag_ended.emit()
