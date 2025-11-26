extends Node2D
@onready var cardmanager: CardManager = $"../Cardmanager"
@onready var playerhand: Hand = $"../Playerhand"

const CARD = preload("uid://d36vamsycohxs")
var deck = [1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_card():
	var  card_drawn  = deck[0]
	deck.erase(card_drawn)
	if deck.size() ==0 :
		$Area2D/CollisionShape2D.disabled = true
		visible = false
	
	
	var new_card :Card= CARD.instantiate()
	new_card.position = position
	
	new_card.value = card_drawn
	cardmanager.add_child(new_card)
	new_card.cardimg.frame = card_drawn -1
	new_card.name = "card"
	playerhand.add_card_to_hand(new_card)
	new_card.animation_player.play("flip")
	
