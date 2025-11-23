class_name DialogueWrapper extends RefCounted

var dialogue_res: DialogueResource
var current_id: String = ""

static func from(file: StringName) -> DialogueWrapper:
	var wrapper := new()
	wrapper.dialogue_res = load(file)
	return wrapper

func get_line_at(id: String = "") -> DialogueLine:
	return await DialogueManager.get_next_dialogue_line(dialogue_res, id)

func set_pointer(ptr: String) -> void: current_id = ptr

func get_next_line() -> DialogueLine:
	var line := await DialogueManager.get_next_dialogue_line(dialogue_res, current_id)
	if not line: return
	current_id = line.next_id
	return line

func get_current_line() -> DialogueLine:
	return await DialogueManager.get_line(dialogue_res, current_id, [])
