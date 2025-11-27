extends Node
@onready var playercardslots: Node2D = $"../Playercardslots"
@onready var deck: Node2D = $"../Deck"

@onready var opponentcardslots: Node2D = $"../Opponentcardslots"
@onready var opponenthand: Opponent_Hand = $"../Opponenthand"
@onready var opponent_timer: Timer = $"../OpponentTimer"
var opponents_choosen_cards = [] 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oppnents_move()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func oppnents_move():
	choose_cards()
	var i = 2
	for cardslot :CardSlot in opponentcardslots.get_children():
		opponent_timer.start()
		await  opponent_timer.timeout
		var chosen_card :Card= opponents_choosen_cards[i]
		i -= 1
		opponenthand.animate_card_to_position(chosen_card,cardslot.position)
		opponenthand.remove_card_from_hand(chosen_card)
		chosen_card.z_index -=1
		
		cardslot.card_in_slot = chosen_card
		
func choose_cards():
	var opponents_sorted_hand =[]
	for i in range(opponenthand.player_hand.size()):
		if opponenthand.player_hand[i].value not in opponents_sorted_hand:
			opponents_sorted_hand.insert(0,opponenthand.player_hand[i].value)
	opponents_sorted_hand.sort()
	if  opponents_sorted_hand.size()<3:
		print("not enough unique cards pivot to random cards logic here")
	else:
		for i in range(3):
			var card
			for j in range(opponenthand.player_hand.size()):
				if opponenthand.player_hand[j].value == opponents_sorted_hand[opponents_sorted_hand.size() -1 -i]:
					card = opponenthand.player_hand[j]
					break
			opponents_choosen_cards.insert( i,card)
	
func check_card_slots ()->bool:
	for cardslot : CardSlot in playercardslots.get_children():
		if !cardslot.card_in_slot:
			return false
	return true

func _on_button_pressed() -> void:
	if check_card_slots():
		$"../Button".disabled = true
		for i in range(3):
			playercardslots.get_children()[i].card_in_slot.animation_player.play("flip")
			opponentcardslots.get_children()[i].card_in_slot.animation_player.play("flip")
			opponent_timer.start()
			
			await  opponent_timer.timeout
		check_values()
	else:
		print("place 3 cards first")

func check_values():
	var playersum = 0
	var opponentsum = 0
	for i in range(3):
		if i >0 and (playercardslots.get_children()[i].card_in_slot.value <= playercardslots.get_children()[i-1].card_in_slot.value ):
			playersum = 0
		else :
			playersum += playercardslots.get_children()[i].card_in_slot.value 
		if i >0 and (opponentcardslots.get_children()[i].card_in_slot.value <= opponentcardslots.get_children()[i-1].card_in_slot.value ):
			opponentsum = 0
		else :
			opponentsum += opponentcardslots.get_children()[i].card_in_slot.value 
	
	if playersum > opponentsum:
		print("YOU WON THE WAVE CRASH" + str(playersum) +str(opponentsum))
	elif  playersum == opponentsum:
		print("THE WAVES ARE EQUAL" )
	else :
		print("YOU LOST THE WAVE CRASH"  + str(playersum) +str(opponentsum))
	reset_board()


func reset_board():
	for i in range(3):
		playercardslots.get_children()[i].card_in_slot.queue_free()
		opponentcardslots.get_children()[i].card_in_slot.queue_free()
		opponent_timer.start()
		
		await  opponent_timer.timeout
	$"../Button".disabled = false
	deck.round_draw()
	oppnents_move()
	
