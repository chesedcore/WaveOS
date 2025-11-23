##a class used to track responses made by the player.
class_name Response extends RefCounted

var next: String
var text: String

static func from(nxt: String, txt: String) -> Response:
	var res := new()
	res.next = nxt
	res.text = txt
	return res 
