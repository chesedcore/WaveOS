class_name ProgramContainerWindow extends Panel

@export var drag_bar: DragBar

var offset_vec: Vector2
var is_dragging: bool = false

func _process(_delta: float) -> void:
	if not is_dragging: return
	self.global_position = offset_vec + get_global_mouse_position()

func _ready() -> void:
	wire_up_signals()
	await get_tree().process_frame

func wire_up_signals() -> void:
	drag_bar.drag_started.connect(_on_drag_started)
	drag_bar.drag_ended.connect(_on_drag_ended)

func _on_drag_started() -> void:
	offset_vec = self.global_position - get_global_mouse_position()
	is_dragging = true

func _on_drag_ended() -> void:
	is_dragging = false
