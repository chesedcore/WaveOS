@tool
class_name LogIcon extends MarginContainer

@export var program_res: ProgramResource:
	set(val):
		program_res = val
		if not val: return
		if Engine.is_editor_hint(): return
		val.visuals_changed.connect(_update_appearance)
@export var icon_rect: TextureRect
@export var name_label: RichTextLabel
@export_tool_button("Update Visuals") var update: Callable = _update_appearance
@export_category("Log file")
@export_file("*.dialogue") var log_dialogue: String
@export var timestamp_str: String = "10 years ago"

func _ready() -> void:
	wire_up_signals()
	_update_appearance()

func wire_up_signals() -> void:
	if Engine.is_editor_hint(): return
	icon_rect.gui_input.connect(_on_icon_gui_input)

func _on_icon_gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Bus.view_log.emit(timestamp_str, log_dialogue, program_res.name)

func _update_appearance() -> void:
	if not program_res: return
	self.icon_rect.texture = program_res.icon
	self.name_label.text = program_res.name
