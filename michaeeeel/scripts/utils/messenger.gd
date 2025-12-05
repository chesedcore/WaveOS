class_name Messenger extends Minigame

@export var message_dock: VBoxContainer
@export var choice_dock: PanelContainer
@export_file("*.dialogue") var dialogue_file: String
@export var scrollbar: SmoothScrollContainer

func _ready() -> void:
	#Data.primary_chat = ChatRes.from(dialogue_file)
	if not Data.primary_chat: return
	
	if Data.primary_chat.needs_rebuild:
		rebuild_chat()
		return
	
	if not Data.primary_chat.needs_rebuild:
		Data.primary_chat.needs_rebuild = true
	roll_chat()

func roll_chat() -> void:
	if not Data.primary_chat: return
	print("--Data.primary_chat rollout started--")
	while true:
		await get_tree().create_timer(1.5).timeout
		print("Walking ahead...")
		var item: ChatItem = await Data.primary_chat.get_next_dialogue()
		prints("Item get: ", item)
		if not item: break
		match item.type:
			ChatItem.TYPE.MESSAGE:
				print("It's a message.")
				add_message(item)
			ChatItem.TYPE.CHOICE:
				print("It's a choice...")
				add_choices(item)
				#Data.primary_chat.set_stop_limit(item.id)
				print("Setting rebuild ID to ",item.id, " and breaking.")
				break

func add_message(msg: Message) -> void:
	await get_tree().process_frame
	message_dock.add_child(msg)
	push_scrollbar_down()

func add_choices(choice: ChoiceContainer) -> void:
	choice_dock.add_child(choice)
	choice.choice_determined.connect(chosen)

func chosen(cont: ChoiceContainer, choice_text: String, next_id: String) -> void:
	var msg := Message.from(Data.protagonist_user, choice_text, Data.systime)
	message_dock.add_child(msg)
	Data.primary_chat.wrapper.set_pointer(next_id)
	
	#Data.primary_chat.set_stop_limit("")
	
	print_rich("[color=blue]Added "+cont.id+" -> "+next_id+" to the cache.")
	Data.primary_chat.choices_cache[cont.id] = Response.from(next_id, choice_text)
	cont.queue_free()
	roll_chat()

func push_scrollbar_down() -> void:
	var scroll := scrollbar.get_v_scroll_bar()
	var maxv := scroll.max_value
	scroll.set_deferred("scroll_vertical", maxv)

func rebuild_chat() -> void:
	if not Data.primary_chat: return
	var seen: Array[String] = []
	Data.primary_chat.reset_pointer()
	print("The pointer has been reset back to an empty string.")
	print("--rebuilding Data.primary_chat--")
	while true:
		print("Attempting cached retrieval...")
		var item: ChatItem = await Data.primary_chat.get_next_cached(seen)
		print("Obtained item:", item)
		if not item: break
		match item.type:
			ChatItem.TYPE.MESSAGE:
				print("It's a message.")
				add_message(item)
				push_scrollbar_down()
			ChatItem.TYPE.CHOICE:
				print("It's a choice. Stop here.")
				add_choices(item)
				break
