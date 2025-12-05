extends Node

#wire up everything

signal allow_action
signal close_action

signal game_event_intent(event_id: String)
signal nonpropagating_event(event_id: String)
signal game_event

signal day_one_sequence_finished
signal proceed_day_2

##mizuko's flag
var is_mizuko_onscreen: bool = false

func _ready() -> void:
	game_event_intent.connect(_event_occured)
	nonpropagating_event.connect(_on_non_propagating_event)

func get_flag(flag_name: String) -> bool:
	return get(flag_name)

func set_flag(flag_name: String) -> void:
	set(flag_name, true)

func _event_occured(event_id: String) -> void:
	print_rich("[color=green]Event id '"+event_id+"' has fired!")
	set_flag(event_id)
	game_event.emit()

func _on_non_propagating_event(event_id: String) -> void:
	print_rich("[color=green]Event id '"+event_id+"' has fired!")
	set_flag(event_id)

func spin_until_signal(sig: Signal, expected_args = null) -> void:
	allow_action.emit()
	print_rich("[color=white]Spinlock acquired. Listening for signal: "+str(sig))
	if expected_args: print_rich("[color=white]With expected args: "+str(expected_args))
	while true:
		var args = await sig
		if not expected_args: break
		if args == expected_args: break
	print_rich("[color=white]Spinlock released.")
	close_action.emit()

func spin_until_app_opened(appname: String) -> void:
	await spin_until_signal(Bus.app_opened, appname)

func spin_until_image_viewed(image_name: String) -> void:
	await spin_until_signal(Bus.image_opened, image_name)

func spin_until_log_viewed(log_name: String) -> void:
	await spin_until_signal(Bus.log_opened, log_name)

func spin_until_event_id(event_id: String) -> void:
	await spin_until_signal(Gamestate.game_event_intent, event_id)

func spin_until_nonpropagating_event_id(event_id: String) -> void:
	await spin_until_signal(Gamestate.nonpropagating_event, event_id)

func spin_until_anything_closes() -> void:
	await spin_until_signal(Bus.request_close_from_res)

##FLAGS

var test_case := false
var talked_to_marina_day_one := false
