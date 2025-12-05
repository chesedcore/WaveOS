class_name LogViewer extends Minigame

@export var message_dock: VBoxContainer
var custom_timestamp: String

#needs init
var chat: ChatRes

func configure(timestamp: String, log_path: String, roll: bool = true) -> void:
	custom_timestamp = timestamp
	chat = ChatRes.from(log_path as StringName, null)
	if roll: roll_chat()

func roll_chat() -> void:
	print("--chat rollout started--")
	while true:
		print("Walking ahead...")
		var item: ChatItem = await chat.get_next_dialogue()
		prints("Item get: ", item)
		if not item: break
		match item.type:
			ChatItem.TYPE.MESSAGE:
				var msg: Message = item
				msg.time.set_text(custom_timestamp)
				msg.metadata.set_text("Info obtained via defragmentation analysis and might not be accurate.")
				print("It's a message.")
				add_message(msg)
			ChatItem.TYPE.CHOICE:
				push_error("Impossible case reached. Do not include choices within log files.")

func add_message(msg: Message) -> void:
	message_dock.add_child(msg)
