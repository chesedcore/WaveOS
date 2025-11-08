class_name Program extends Control

@export var subviewport: SubViewport
@export var exit_button: FrameButton
@export var program_name: RichTextLabel
@export var game_icon: TextureRect

var program_res: ProgramResource

func wrap(minigame: Minigame) -> void:
	subviewport.add_child(minigame)

func set_program_attr() -> void:
	assert(program_res, "The program doesn't have any resource to go off of...")
	program_name.set_text(program_res.name)
	game_icon.texture = program_res.icon

func _ready() -> void:
	wire_up_signals()

func wire_up_signals() -> void:
	exit_button.clicked.connect(Bus.request_close_from_res.emit.bind(program_res))
