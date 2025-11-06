class_name ProgramIcon extends MarginContainer

@export var icon_rect: TextureRect

func _ready() -> void:
	icon_rect.gui_input.connect(_on_icon_gui_input)

func _on_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Bus.request_open_from_icon.emit(self)
