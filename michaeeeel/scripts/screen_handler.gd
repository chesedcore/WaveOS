class_name ScreenHandler extends Control

@export var program_wrapper: PackedScene = preload("res://scenes/program.tscn")

@export var program_dock: Control
@export var bottom_bar: BottomBar

@export var program_count_limit: int = 9


var registry: Dictionary[ProgramResource, RegistryEntry] = {
	
}

#special programs that i need to hardcode for
@export_category("Special Programs")
@export var messenger_res: ProgramResource

func _ready() -> void:
	wire_up_signals()

func _process(_delta: float) -> void:
	assert(print_orphaned_nodes())

func print_orphaned_nodes() -> bool:
	if get_orphan_node_ids(): print_orphan_nodes()
	return true

func wire_up_signals() -> void:
	Bus.request_open_from_icon.connect(_on_icon_open_request)
	Bus.request_close_from_res.connect(_on_close_request)
	Bus.request_focus.connect(_on_requested_focus)
	Bus.message_arrived.connect(_on_message_arrived)
	Gamestate.game_event.connect(_on_game_event_occured)

func _on_icon_open_request(program_icon: ProgramIcon) -> void:
	
	#do not allow programs above a limit, or UI explodes lmao
	if registry.size() >= program_count_limit:
		print_rich("[color=red]Too many programs, request denied.")
		return
	
	#check if that program already exists, and if so, deny it
	var key_res: ProgramResource = program_icon.program_res
	if key_res in registry:
		print_rich("[color=red]That program is already open.")
		return
	
	#open up a program
	print("Request to open program from icon: ", program_icon)
	var program: Program = program_wrapper.instantiate()
	program.program_res = key_res
	program_dock.add_child.call_deferred(program)
	await program.ready
	
	#add the minigame to the program
	var scene: Minigame = load(key_res.program).instantiate()
	program.wrap.call_deferred(scene)
	await scene.ready
	program.set_program_attr()
	print("Request served, opened path at ", key_res.program)
	
	#add the program's task to the taskbar
	var task := bottom_bar.add_to_taskbar(key_res)
	print("Added that program to the taskbar.")
	
	#add both the program and the task to the registry
	registry[key_res] = RegistryEntry.from(program, task)
	print("Added both to the registry.")

func _on_close_request(program_res: ProgramResource) -> void:
	print("Request to close constructs associated with ",program_res, " received.")
	assert(program_res in registry, "Key doesn't exist in the registry... what teh fuck?")
	
	#get data from the registry and delete that entry
	var entry := registry[program_res]
	registry.erase(program_res)
	print("Obtained registry entry. Entry deleted.")
	
	#destroy both nodes linked inside the registry
	entry.destroy()
	print("Program closed.")

func _on_requested_focus(program: Program) -> void:
	program.move_to_front()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("test_case_switch"):
		Gamestate.game_event_intent.emit("test_case")

func _on_game_event_occured() -> void:
	roll_messenger()

func _on_message_arrived(user: String, text: String) -> void:
	print_rich("[color=white]"+user+": "+text)

func is_program_active(program_res: ProgramResource) -> bool:
	if not program_res in registry: return false
	var link := registry[program_res]
	var program := link.linked_program
	return program_dock.get_child(-1) == program

func roll_messenger() -> void:
	#if the messenger is active, you roll the chat inside the messenger.
	#otherwise you insert push notifs.
	Data.test_res.force_roll()
