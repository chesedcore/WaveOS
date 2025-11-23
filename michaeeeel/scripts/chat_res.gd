##a class that encapsulates an entire chat
class_name ChatRes extends Resource

const INDETERMINATE := "balls"

#needs init
var wrapper: DialogueWrapper

var needs_rebuild: bool = false
var rebuild_till: String = ""

##a dict that maps the choices id to the chosen response id
var choices_cache: Dictionary[String, Response]

static func from(dialogue_file: StringName) -> ChatRes:
	var chat := new()
	chat.wrapper = DialogueWrapper.from(dialogue_file)
	return chat

func get_next_dialogue() -> ChatItem:
	var line := await wrapper.get_next_line()
	if not line: return null
	
	if not line.responses:
		return get_message_from(line)
	
	return get_choice_pane_from(line)

func get_message_from(line: DialogueLine) -> Message:
	var user: User = Data.username_to_user[line.character]
	var text := line.text
	var timestamp := "REPLACE_THIS_LATER"
	return Message.from(user, text, timestamp)

func get_choice_pane_from(line: DialogueLine) -> ChatItem:
	return ChoiceContainer.from(line)

func reset_pointer() -> void:
	wrapper.set_pointer("")

func get_next_cached(seen: Array[String]) -> ChatItem:
	var line := await wrapper.get_current_line()
	if not line: return
	
	if line.responses:
		print_rich("[color=yellow]branch:"+line.text)
		print_rich("[color=blue]Seeing if line id "+line.id+" exists in the cache...")
		var chosen_response: Response = choices_cache.get(line.id)
		if not chosen_response or line.id in seen: 
			if chosen_response: print_rich("[color=red]cyclic dependency detected! breaking!")
			else: print("Not found in the cache, retrieving the choices instead.")
			return ChoiceContainer.from(line)
		
		var chosen_response_id := chosen_response.next
		print_rich("[color=blue]Found in the cache!"+line.id+"->"+chosen_response_id)
		wrapper.set_pointer(chosen_response_id)
		seen.push_back(line.id)
		return Message.from(Data.protagonist_user, chosen_response.text, "REPLAAACE")
	
	wrapper.set_pointer(line.next_id)
	return Message.from(
		Data.username_to_user[line.character],
		line.text, "REPLACE_THIS_SHIT_SOON"
	)
