class_name ScreenHandler extends Control

@export var program_dock: Control

func _ready() -> void:
	wire_up_signals()

func wire_up_signals() -> void:
	Bus.request_open_from_icon.connect(_on_icon_open_request)

func _on_icon_open_request(program_icon: ProgramIcon) -> void:
	print("Request to open program from icon: ", program_icon)
