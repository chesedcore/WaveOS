@abstract class_name Minigame
extends Control


signal won_minigame


signal lost_minigame

## call when double clicked on "desktop" icon
func start_minigame() -> void:
	pass


## emit when clicking exit button in minigame or the close button of the game's window
func exit_minigame() -> void:
	pass
