class_name Terminal extends Minigame

@export var buffer: LineEdit
@export var output_container: VBoxContainer
@export var scroll: SmoothScrollContainer
@export var terminal_machine: TerminalMachine

func _ready() -> void:
	wire_up_signals()
	buffer.grab_focus.call_deferred()

func wire_up_signals() -> void:
	buffer.text_submitted.connect(_on_text_submitted)

func _on_text_submitted(cmd: String) -> void:
	buffer.clear()
	
	var cleaned_str := cmd.strip_edges()
	if not cleaned_str: return
	
	var stdout: String = get_output_from(cleaned_str)
	var output := Output.from(cleaned_str, stdout)
	output_container.add_child(output)
	
	var max_scroll := scroll.get_v_scroll_bar().max_value
	scroll.set_deferred("scroll_vertical", max_scroll)

func get_output_from(cmd: String) -> String:
	return terminal_machine.perform_processing(cmd)
