class_name Program extends Control

@export var subviewport: SubViewport
@export var expand_shrink_button: ExpandShrinkButton
@export var exit_button: FrameButton
@export var program_name: RichTextLabel
@export var game_icon: TextureRect
@export var window: ProgramContainerWindow

var program_res: ProgramResource

var original_pos: Vector2
var window_original_size: Vector2
var window_max_size: Vector2

func wrap(minigame: Minigame) -> void:
	subviewport.add_child(minigame)

func set_program_attr() -> void:
	assert(program_res, "The program doesn't have any resource to go off of...")
	program_name.set_text(program_res.name)
	game_icon.texture = program_res.icon

func configure_original_sizes() -> void:
	window_original_size = window.size
	window_max_size = self.size
	original_pos = window.position

func _ready() -> void:
	scale = Vector2(2, 0)
	wire_up_signals()
	#await get_tree().process_frame
	configure_original_sizes()
	pop_out()


func wire_up_signals() -> void:
	exit_button.clicked.connect(Bus.request_close_from_res.emit.bind(program_res))
	expand_shrink_button.clicked.connect(_on_expand_shrink_clicked)

var tween: Tween
func pop_out() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)

func shrink_in() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2(2, 0), 0.4)
	tween.tween_callback(queue_free)

var size_tween: Tween
func _on_expand_shrink_clicked() -> void:
	if size_tween: tween.kill()
	
	if expand_shrink_button.mode == ExpandShrinkButton.MODE.WINDOWED:
		if not window.position.is_equal_approx(original_pos):
			var recenter_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			recenter_tween.tween_property(window, "position", original_pos, 0.3)
			await recenter_tween.finished
		size_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		_tween_window_to_size(size_tween, window_max_size)
		size_tween.tween_callback(
			func() -> void: expand_shrink_button.mode = ExpandShrinkButton.MODE.MAX_STRETCH
		)
	else:
		size_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		_tween_window_to_size(size_tween, window_original_size)
		size_tween.tween_callback(
			func() -> void: expand_shrink_button.mode = ExpandShrinkButton.MODE.WINDOWED
		)

func _tween_window_to_size(t: Tween, target_size: Vector2, duration: float = 0.4) -> void:
	var old_size := window.size
	var center := window.position + old_size * 0.5
	var target_pos := center - target_size * 0.5

	t.tween_property(window, "size", target_size, duration)
	t.parallel().tween_property(window, "position", target_pos, duration)
