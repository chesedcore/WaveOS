@tool
class_name CenteringControl extends Control

@export_tool_button("Center") var callable: Callable = center

func center() -> void:
	pivot_offset = size/2
