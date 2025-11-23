extends Node

#wire up everything

signal game_event_intent(event_id: String)
signal game_event

func _ready() -> void:
	game_event_intent.connect(_event_occured)

func get_flag(flag_name: String) -> bool:
	return get(flag_name)

func set_flag(flag_name: String) -> void:
	set(flag_name, true)

func _event_occured(event_id: String) -> void:
	print_rich("[color=green]Event id '"+event_id+"' has fired!")
	set_flag(event_id)
	game_event.emit()

##FLAGS

var test_case := false
