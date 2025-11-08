class_name Task extends PanelContainer

@export var icon: TextureRect

func change_icon(to: Texture) -> void:
	icon.texture = to
