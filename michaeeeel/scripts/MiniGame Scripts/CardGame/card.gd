class_name Card
extends Node2D

signal hovered_on
signal hovered_off
var value:int
var is_in_slot = false
@onready var cardimg: AnimatedSprite2D = $cardimg
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var hand_position : Vector2

func _ready() -> void:
	
	if get_parent() is CardManager:
		get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	hovered_on.emit(self)



func _on_area_2d_mouse_exited() -> void:
	
	hovered_off.emit(self)
