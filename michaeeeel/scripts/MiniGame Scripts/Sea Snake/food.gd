class_name  Food

var position :Vector2
var size : Vector2 = Vector2(32,32)
var color = Color.RED
func get_rect():
	return Rect2(position,size)
