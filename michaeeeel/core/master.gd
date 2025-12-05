class_name Master extends Node

@export var game_dock: Control
@export var transition_dock: Control
@export var fade_rect: ColorRect

const day_two_icons: Array[String] = [
	"res://scenes/icons/beach_breaker_icon.tscn",
	"res://scenes/icons/beach_pinball_icon.tscn",
	"res://scenes/icons/cat_image_icon.tscn",
	"res://scenes/icons/log_0x001_icon.tscn",
	"res://scenes/icons/messenger_icon.tscn",
	"res://scenes/icons/sea_snake_icon.tscn",
	"res://scenes/icons/trashsweeper_icon.tscn",
	"res://scenes/icons/wave_crash_icon.tscn"
]

func _ready() -> void:
	wire_up_signals()
	prelude()

func wire_up_signals() -> void:
	Bus.end_day_one.connect(_on_day_one_end)

func prelude() -> void:
	var os := preload("res://scenes/os.tscn").instantiate()
	game_dock.add_child.call_deferred(os)
	await os.ready
	var indicator := DayIndicator.from("DAY ONE")
	transition_dock.add_child(indicator)
	indicator.died.connect(start_day_one)

func start_day_one() -> void:
	Bus.summon_mizuko.emit(preload("res://dialogue/mizuko_intro.dialogue"))

func _on_day_one_end() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(fade_rect, "color", Color.BLACK, 0.8)
	Bus.destroy_all_icons.emit()
	for path in day_two_icons: Bus.add_icon.emit(path)
	if tween and tween.is_running(): await tween.finished
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	t.tween_property(fade_rect, "color", Color.TRANSPARENT, 0.8)
	t.tween_callback(day_two_prelude)

func day_two_prelude() -> void:
	var indicator := DayIndicator.from("DAY TWO")
	transition_dock.add_child(indicator)
	indicator.died.connect(start_day_two)

func start_day_two() -> void:
	Bus.summon_mizuko.emit(preload("res://dialogue/mizuko_two.dialogue"))
