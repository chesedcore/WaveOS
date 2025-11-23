class_name Messenger extends Minigame

@export var message_dock: VBoxContainer
@export var choice_dock: PanelContainer
@export_file("*.dialogue") var dialogue_file: String

#needs init
var chat: ChatRes

func _ready() -> void:
	#chat = ChatRes.from(dialogue_file)
	chat = Data.test_res
	
	if chat.needs_rebuild:
		rebuild_chat()
		return
	
	if not chat.needs_rebuild:
		chat.needs_rebuild = true
	roll_chat()

func roll_chat() -> void:
	print("--chat rollout started--")
	while true:
		print("Walking ahead...")
		var item: ChatItem = await chat.get_next_dialogue()
		prints("Item get: ", item)
		if not item: break
		match item.type:
			ChatItem.TYPE.MESSAGE:
				print("It's a message.")
				add_message(item)
			ChatItem.TYPE.CHOICE:
				print("It's a choice...")
				add_choices(item)
				chat.rebuild_till = item.id
				print("Setting rebuild ID to ",item.id, " and breaking.")
				break

func add_message(msg: Message) -> void:
	message_dock.add_child(msg)
	#crash on memory leak
	if message_dock.get_child_count() > 20:
		print("Crash! Memory leak detected!") 
		get_tree().quit()

func add_choices(choice: ChoiceContainer) -> void:
	choice_dock.add_child(choice)
	choice.choice_determined.connect(chosen)

func chosen(cont: ChoiceContainer, choice_text: String, next_id: String) -> void:
	var msg := Message.from(Data.protagonist_user, choice_text, "REPLACE_THIS")
	message_dock.add_child(msg)
	chat.wrapper.set_pointer(next_id)
	print_rich("[color=blue]Added "+cont.id+" -> "+next_id+" to the cache.")
	chat.choices_cache[cont.id] = Response.from(next_id, choice_text)
	cont.queue_free()
	roll_chat()

func rebuild_chat() -> void:
	var seen: Array[String] = []
	chat.reset_pointer()
	print("The pointer has been reset back to an empty string.")
	print("--rebuilding chat--")
	while true:
		print("Attempting cached retrieval...")
		var item: ChatItem = await chat.get_next_cached(seen)
		print("Obtained item:", item)
		if not item: break
		match item.type:
			ChatItem.TYPE.MESSAGE:
				print("It's a message.")
				add_message(item)
			ChatItem.TYPE.CHOICE:
				print("It's a choice. Stop here.")
				add_choices(item)
				break
