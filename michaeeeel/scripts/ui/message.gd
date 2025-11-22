class_name Message extends PanelContainer

@export var icon: TextureRect
@export var username: RichTextLabel
@export var time: RichTextLabel
@export var metadata: RichTextLabel

@export var actual_text: RichTextLabel
@export var media_container: GridContainer

static func message_from(
	user: User, 
	text: String, 
	post_time: String, 
	media: Array[Texture] = []
) -> Message:
	var msg: Message = load("res://scenes/utility/messenger/message.tscn").instantiate()
	msg.actual_text.set_text(text)
	msg.icon.texture = user.pfp
	msg.username.set_text(user.username)
	msg.time.set_text(post_time)
	if not media: return msg
	for medium in media:
		var texture_rect := TextureRect.new()
		texture_rect.texture = medium
		msg.media_container.add_child(texture_rect)
	return msg

static func from_res(message_res: MessageRes) -> Message:
	var msg: Message = load("res://scenes/utility/messenger/message.tscn").instantiate()
	msg.actual_text.set_text(message_res.content)
	msg.icon.texture = message_res.user.pfp
	msg.username.set_text(message_res.user.username)
	msg.time.set_text(message_res.timestamp)
	for medium in message_res.media:
		var texture_rect := TextureRect.new()
		texture_rect.texture = medium
		msg.media_container.add_child(texture_rect)
	return msg
