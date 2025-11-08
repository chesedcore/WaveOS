class_name ScreenHandler extends Control

@export var program_wrapper: PackedScene = preload("res://scenes/program.tscn")

@export var program_dock: Control
@export var bottom_bar: BottomBar

var registry: Dictionary[ProgramResource, RegistryEntry] = {
	
}

func _ready() -> void:
	wire_up_signals()

func wire_up_signals() -> void:
	Bus.request_open_from_icon.connect(_on_icon_open_request)
	Bus.request_close_from_res.connect(_on_close_request)

func _on_icon_open_request(program_icon: ProgramIcon) -> void:
	
	#open up a program
	print("Request to open program from icon: ", program_icon)
	var program: Program = program_wrapper.instantiate()
	program.program_res = program_icon.program_res
	program_dock.add_child.call_deferred(program)
	await program.ready
	
	#add the minigame to the program
	var scene: Minigame = load(program_icon.program_res.program).instantiate()
	program.wrap.call_deferred(scene)
	await scene.ready
	print("Request served, opened path at ", program_icon.program_res.program)
	
	#add the program's task to the taskbar
	var task := bottom_bar.add_to_taskbar(program_icon.program_res)
	print("Added that program to the taskbar.")
	
	#add both the program and the task to the registry
	registry[program_icon.program_res] = RegistryEntry.from(program, task)
	print("Added both to the registry.")

func _on_close_request(program_res: ProgramResource) -> void:
	print("Request to close constructs associated with ",program_res, " received.")
	assert(program_res in registry, "Key doesn't exist in the registry... what teh fuck?")
	
	var entry := registry[program_res]
	registry.erase(program_res)
	print("Obtained registry entry. Entry deleted.")
	
	entry.destroy()
	print("Program closed.")
