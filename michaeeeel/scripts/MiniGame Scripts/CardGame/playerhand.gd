
class_name  Hand

extends Node2D


const CARD_WIDTH = 100
const  HAND_Y_POS = 600


@onready var cardmanager: CardManager = $"../Cardmanager"

var player_hand = []
var center_screen_x
func _ready() -> void:
	center_screen_x = get_viewport().size.x /2

		

func add_card_to_hand(card : Card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_position()
	else:
		animate_card_to_position(card,card.hand_position)
	
	
func update_hand_position():
	for i in range(player_hand.size()):
		var new_position = Vector2( calculate_card_position(i),HAND_Y_POS)
		var card : Card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)
		
func calculate_card_position(index : int):
	var total_width = (player_hand.size() -1 ) * CARD_WIDTH
	var x_offset = (center_screen_x + index * CARD_WIDTH - total_width/2 )+150
	return x_offset
	
	
	
func animate_card_to_position(card : Card, new_position : Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position",new_position,0.1)
	
	
	
func remove_card_from_hand(card :Card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position()
