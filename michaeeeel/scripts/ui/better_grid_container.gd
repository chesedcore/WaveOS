@tool
class_name VerticalFlowContainer extends Container

@export var v_spacing: int = 4
@export var h_spacing: int = 8

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_resort()
	elif what == NOTIFICATION_RESIZED:
		# When our size changes, request a relayout
		queue_sort()

func _resort() -> void:
	var children: Array[Control] = []
	for c in get_children():
		# Only layout Controls that are visible
		if c is Control and c.visible:
			children.append(c)
	if children.size() == 0:
		return

	var max_height : float = size.y
	var x := 0.0
	var y := 0.0
	var column_width := 0.0

	for child in children:
		# get_combined_minimum_size accounts for margins and containers inside child
		var min_size: Vector2 = child.get_combined_minimum_size()

		# If this child won't fit vertically, start a new column
		if y + min_size.y > max_height and y > 0:
			x += column_width + h_spacing
			y = 0
			column_width = 0

		# Place the child. fit_child_in_rect is provided by Container and handles anchors/margins correctly.
		fit_child_in_rect(child, Rect2(Vector2(x, y), min_size))

		y += min_size.y + v_spacing
		column_width = max(column_width, min_size.x)
