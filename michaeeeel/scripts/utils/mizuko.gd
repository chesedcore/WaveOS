class_name Mizuko extends Control

@export var balloon: Balloon
@export var mizuko: Sprite2D
@export var box: Control

@onready var mizuko_original_position := mizuko.global_position

@export var mood_dict: Dictionary[String, Texture] = {
	
}

func _ready() -> void:
	balloon.no_more.connect(_on_end)
	Gamestate.allow_action.connect(disappear)
	Gamestate.close_action.connect(appear)
	Bus.mizuko_morph.connect(_on_mizuko_morph)
	transition_in()

func _on_mizuko_morph(emotion: String) -> void:
	var texture: Texture = mood_dict.get(emotion.to_lower(), mood_dict["neutral"])
	mizuko.texture = texture

func start_dialogue(dialogue_res: DialogueResource) -> void:
	balloon.start(dialogue_res)

func _on_end() -> void:
	print_rich("[color=red]Reached end of dialogue.")
	@warning_ignore("shadowed_variable")
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(mizuko, "global_position", mizuko_original_position, 0.5)
	tween.parallel().tween_property(box, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(reset_state)

func reset_state() -> void:
	Gamestate.is_mizuko_onscreen = false
	Bus.mizuko_destroyed.emit()
	queue_free()

func transition_in() -> void:
	box.pivot_offset = box.size / 2
	box.scale = Vector2.ZERO
	@warning_ignore("shadowed_variable")
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(mizuko, "global_position:x", 950, 1)
	tween.parallel().tween_property(box, "scale", Vector2.ONE, 1)

var tween: Tween
func disappear() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(mizuko, "global_position", mizuko_original_position, 0.5)
	tween.tween_callback(func() -> void: mouse_filter = MOUSE_FILTER_IGNORE)

func appear() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(mizuko, "global_position:x", 950, 1)
	tween.tween_callback(func() -> void: mouse_filter = Control.MOUSE_FILTER_STOP)
