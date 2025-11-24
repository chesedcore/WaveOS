class_name  SnakeSegmant

var curr_position :Vector2 :set = _set_cur_position
var pre_position : Vector2
var size : Vector2
var color : Color

func get_rect() -> Rect2:
	return Rect2(curr_position,size)

func go_to_prev_pos():
	curr_position = pre_position


func _set_cur_position(new_position : Vector2):
	pre_position = curr_position
	curr_position = new_position
