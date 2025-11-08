class_name Output extends MarginContainer

@export var command_text: RichTextLabel
@export var stdout_text: RichTextLabel

static func from(cmd: String, stdout: String) -> Output:
	var output: Output = preload("res://scenes/utility/terminal/output.tscn").instantiate()
	output.command_text.text = "> "+cmd
	output.stdout_text.text = stdout
	return output
