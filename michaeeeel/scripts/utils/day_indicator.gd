@tool
class_name DayIndicator extends CanvasLayer

@export var label: RichTextLabel
@export var timer: Timer
@export var root: Control

@export_tool_button("Center Pivot") var center: Callable = _center_this_control

signal died

static func from(text: String) -> DayIndicator:
	var indicator: DayIndicator = load("res://scenes/utility/day_indicator.tscn").instantiate()
	indicator.label.set_text(text)
	return indicator

func _center_this_control() -> void:
	root.pivot_offset = root.size/2

func _ready() -> void:
	if Engine.is_editor_hint(): return
	root.scale = Vector2(2, 0)
	pop_out()

func pop_out() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(root, "scale", Vector2.ONE, 0.2)
	tween.tween_callback(start_timer)

func start_timer() -> void:
	timer.start()
	timer.timeout.connect(pop_in)

func pop_in() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(root, "scale", Vector2(2, 0), 0.3)
	tween.tween_callback(func() -> void: died.emit(); queue_free())
