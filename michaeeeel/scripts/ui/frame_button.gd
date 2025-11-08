class_name FrameButton extends TextureRect

signal clicked

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit()
