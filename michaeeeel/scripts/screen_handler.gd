class_name ScreenHandler extends Control

@export var program_dock: Control
@export var program_wrapper: PackedScene = preload("res://scenes/program.tscn")

func _ready() -> void:
	wire_up_signals()

func wire_up_signals() -> void:
	Bus.request_open_from_icon.connect(_on_icon_open_request)

func _on_icon_open_request(program_icon: ProgramIcon) -> void:
	print("Request to open program from icon: ", program_icon)
	var program: Program = program_wrapper.instantiate()
	program_dock.add_child.call_deferred(program)
	await program.ready
	
	#add the minigame to the program
	var scene: Minigame = load(program_icon.program_res.program).instantiate()
	program.wrap.call_deferred(scene)
	await scene.ready
	print("Request served, opened path at ", program_icon.program_res.program)
