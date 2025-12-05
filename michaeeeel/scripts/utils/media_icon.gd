@tool
class_name MediaIcon extends Control

@export var icon_rect: FloatyFuckMediaIcon
@export var label: RichTextLabel
@export var image: Texture
@export var image_name: String
@export_tool_button("Update Visuals") var update: Callable = _update_appearance

func _ready() -> void:
	if Engine.is_editor_hint(): return
	wire_up_signals()
	_update_appearance()

func wire_up_signals() -> void:
	if Engine.is_editor_hint(): return
	gui_input.connect(_on_icon_gui_input)

func _on_icon_gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Bus.view_image.emit(image_name, image)

func _update_appearance() -> void:
	self.icon_rect.texture = image
	self.label.text = image_name

#thanks for the footguns godot :heart:
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and icon_rect.hovering:
		var local_pos: = get_local_mouse_position()
		var center: = size / 2.0
		var _offset: = (local_pos - center) / center
		_offset = _offset.clamp(Vector2(-1, -1), Vector2(1, 1))

		icon_rect.target_x_rot = -_offset.y * icon_rect.MAX_ROT
		icon_rect.target_y_rot = _offset.x * icon_rect.MAX_ROT

func _on_mouse_entered() -> void:
	icon_rect.hovering = true

func _on_mouse_exited() -> void:
	icon_rect.hovering = false
