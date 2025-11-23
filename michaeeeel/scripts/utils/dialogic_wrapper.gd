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

func line_filter(line: DialogueLine) -> DialogueLine:
	if line.tags.is_empty(): return line
	for tag: String in line.tags:
		print_rich("Attempting to check if tag [color=yellow]"+tag+"[/color] is true.")
		if not Gamestate.get_flag(tag): 
			print_rich("[color=red]Tag "+tag+" failed check.")
			return null
	return line

func get_next_line() -> DialogueLine:
	var line := await DialogueManager.get_next_dialogue_line(dialogue_res, current_id)
	line = line_filter(line)
	if not line: return
	current_id = line.next_id
	return line

func get_current_line() -> DialogueLine:
	return line_filter(await DialogueManager.get_line(dialogue_res, current_id, []))
