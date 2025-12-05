class_name Notif extends PanelContainer

@export var username: RichTextLabel
@export var textbox: RichTextLabel
@export var text_limit: int = 108

static func from(user: String, txt: String) -> Notif:
	var notif: Notif = load("res://scenes/utility/messenger/notif.tscn").instantiate()
	if txt.length() > notif.text_limit:
		txt = txt.substr(0, 108)
	notif.username.set_text(user)
	notif.textbox.set_text(txt)
	return notif

var tween: Tween
func _ready() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 3)
	tween.tween_callback(queue_free)
