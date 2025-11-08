class_name Program extends Control

@export var subviewport: SubViewport
@export var exit_button: FrameButton

var program_res: ProgramResource

func wrap(minigame: Minigame) -> void:
	subviewport.add_child(minigame)

func _ready() -> void:
	wire_up_signals()

func wire_up_signals() -> void:
	exit_button.clicked.connect(Bus.request_close_from_res.emit.bind(program_res))
