class_name Program extends Control

@export var subviewport: SubViewport

func wrap(minigame: Minigame) -> void:
	subviewport.add_child(minigame)
