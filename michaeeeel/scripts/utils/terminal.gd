class_name Terminal extends Minigame

@export var buffer: LineEdit
@export var output_container: VBoxContainer
@export var scroll: SmoothScrollContainer

func _ready() -> void:
	wire_up_signals()
	buffer.grab_focus.call_deferred()

func wire_up_signals() -> void:
	buffer.text_submitted.connect(_on_text_submitted)

func _on_text_submitted(cmd: String) -> void:
	buffer.clear()
	var stdout: String = get_output_from(cmd)
	var output := Output.from(cmd, stdout)
	output_container.add_child(output)
	
	var max_scroll := scroll.get_v_scroll_bar().max_value
	scroll.set_deferred("scroll_vertical", max_scroll)

func get_output_from(_string: String) -> String:
	return "Lol nothing implemented yet xD"
