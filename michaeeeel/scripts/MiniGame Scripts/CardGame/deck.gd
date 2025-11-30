extends Node2D
@onready var cardmanager: CardManager = $"../Cardmanager"
@onready var playerhand: Hand = $"../Playerhand"
@onready var opponenthand: Opponent_Hand = $"../Opponenthand"

const CARD = preload("uid://d36vamsycohxs")
const OPPONENTCARD = preload("uid://dp4dkttvsfcmk")

var deck = [1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13]
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func round_draw():
	for i in range(3):
		draw_card(playerhand)
		draw_card(opponenthand)
func draw_card(hand):
	var shuf_chance = randi_range(1,4)
	if shuf_chance ==1 :
		
		deck.shuffle()
	var  card_drawn  = deck[0]
	deck.erase(card_drawn)
	
	if hand is Hand:
		var new_card :Card= CARD.instantiate()
		new_card.position = position
	
		new_card.value = card_drawn
		cardmanager.add_child(new_card)
		new_card.cardimg.frame = card_drawn -1
		new_card.name = "card"
		playerhand.add_card_to_hand(new_card)
		new_card.animation_player.play("flip")
	elif hand is Opponent_Hand  :
		var new_card :Card= OPPONENTCARD.instantiate()
		new_card.position = position
		
		new_card.value = card_drawn
		cardmanager.add_child(new_card)
		new_card.cardimg.frame = card_drawn -1
		new_card.name = "card"
		opponenthand.add_card_to_hand(new_card)
	
	
