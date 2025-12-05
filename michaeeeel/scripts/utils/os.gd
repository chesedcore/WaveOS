class_name OperatingSystem extends Control

@export var desktop: VerticalFlowContainer

func _ready() -> void:
	wire_up_signals()

func wire_up_signals() -> void:
	Bus.destroy_all_icons.connect(destroy_all_icons)
	Bus.add_icon.connect(add_icon)

func destroy_all_icons() -> void:
	for control: Control in desktop.get_children():
		control.queue_free()

func add_icon(string_path: String) -> void:
	print("add command received")
	var icon: Control = load(string_path).instantiate()
	desktop.add_child(icon)
