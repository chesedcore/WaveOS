extends Node
const CARD_PLACE_1 = preload("uid://jplskukhes5o")
const CARD_SLIDE_1 = preload("uid://b6kd2mj8kk54x")
const CARD_FAN_1 = preload("uid://5s8ivfuxhgpw")
const SPLASH_1 = preload("uid://p6n6h5kj1rxa")
const SPLASH_2 = preload("uid://4tkfj8jdkunk")


@onready var playercardslots: Node2D = $"../Playercardslots"
@onready var deck: Node2D = $"../Deck"
@onready var playervalues: RichTextLabel = $"../playervalues"
@onready var opponentvalues: RichTextLabel = $"../opponentvalues"
@onready var gameovertext: RichTextLabel = $"../Gameover/VBoxContainer/gameovertext"
@onready var gameover: ColorRect = $"../Gameover"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

@onready var wavecrashtext: RichTextLabel = $"../Wavecrashcutin/Wavecrashtext"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var health: RichTextLabel = $"../playerHealth/background/ColorRect/health"
@onready var opponent_health: RichTextLabel = $"../opponenthealth/background/ColorRect/health"
var game_end = false
var current_health = 100
var opponent_current_health = 100
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
	audio_stream_player.stream = CARD_PLACE_1
	for cardslot :CardSlot in opponentcardslots.get_children():
		opponent_timer.start()
		await  opponent_timer.timeout
		var chosen_card :Card= opponents_choosen_cards[i]
		i -= 1
		audio_stream_player.play()
		opponenthand.animate_card_to_position(chosen_card,cardslot.position)
		opponenthand.remove_card_from_hand(chosen_card)
		
		chosen_card.z_index -=1
		
		cardslot.card_in_slot = chosen_card
		
func choose_cards():
	opponents_choosen_cards.clear()
	var low_chance = randi_range(1,4)
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
			if low_chance ==1:
				print("doing the lowest")
				for j in range(opponenthand.player_hand.size()):
					if opponenthand.player_hand[j].value == opponents_sorted_hand[i]:
						card = opponenthand.player_hand[j]
						break
			else:
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
		audio_stream_player.stream = CARD_SLIDE_1
		for i in range(3):
			audio_stream_player.play()
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
	var player_bonus = 1
	var opponent_bonus =1
	var player_values_text :String
	var opponents_values_text : String
	var is_consecutive_player = true
	var is_consecutive_opponent = true
	for i in range(3):
		if i >0 and (playercardslots.get_children()[i].card_in_slot.value <= playercardslots.get_children()[i-1].card_in_slot.value ):
			playersum = 0
			is_consecutive_player = false
		else :
			playersum += playercardslots.get_children()[i].card_in_slot.value
			if  i >0 and !(playercardslots.get_children()[i].card_in_slot.value - playercardslots.get_children()[i-1].card_in_slot.value == 1 ):
				is_consecutive_player = false
		if i >0 and (opponentcardslots.get_children()[i].card_in_slot.value <= opponentcardslots.get_children()[i-1].card_in_slot.value ):
			opponentsum = 0
			is_consecutive_opponent = false
		else :
			opponentsum += opponentcardslots.get_children()[i].card_in_slot.value 
			if i >0 and !(opponentcardslots.get_children()[i].card_in_slot.value - opponentcardslots.get_children()[i-1].card_in_slot.value == 1 ):
				is_consecutive_opponent = false
	player_values_text =  "Sum: "+str(playersum)+"\n"
	opponents_values_text =  "Sum: "+str(opponentsum)+"\n"
	var bonus_text = "No Bonus\n"
	if is_consecutive_player:
		player_bonus = 2
		bonus_text = "Consecutive Bonus : x2\n"
		
	if playersum ==36:
		player_bonus = 3
		bonus_text = "Royals Bonus : x3\n"
	player_values_text += bonus_text
	
	bonus_text = "No Bonus\n"
	if is_consecutive_opponent:
		opponent_bonus = 2
		bonus_text = "Consecutive Bonus : x2\n"
	if opponentsum ==36:
		opponent_bonus = 3
		bonus_text = "Royals Bonus : x3\n"

	
	opponents_values_text += bonus_text
	var player_total = playersum * player_bonus
	player_values_text += str(player_total)
	
	
	
	var opponent_total = opponentsum * opponent_bonus
	opponents_values_text += str(opponent_total)
	playervalues.text = player_values_text
	opponentvalues.text = opponents_values_text
	await display_values()

	
	if player_total>opponent_total:
		wavecrashtext.text = "YOU WON THE WAVE CRASH!"
		animation_player.play("cut_in")
		var damage = player_total - opponent_total
		
		await player_wave_animation(playercardslots)
		inflict_Damage_To_Opponent(damage)
		print("YOU WON THE WAVE CRASH" + str(player_total) +str(opponent_total))
	elif  player_total == opponent_total:
		
		wavecrashtext.text = "THE WAVES WERE EQUAL!"
		animation_player.play("cut_in")
	else :
		var damage = opponent_total - player_total
		
		wavecrashtext.text = "YOU LOST THE WAVE CRASH!"
		animation_player.play("cut_in")
		await opponent_wave_animation(opponentcardslots)
		inflict_Damage_To_Player(damage)
		print("YOU LOST THE WAVE CRASH"  + str(player_total) +str(opponent_total))
	if !game_end:
		reset_board()

func opponent_wave_animation(cardslots :Node2D):
	audio_stream_player.stream = SPLASH_1
	audio_stream_player.play()
	var wave_tween = create_tween()
	wave_tween.set_ease(Tween.EASE_OUT)
	wave_tween.set_trans(Tween.TRANS_EXPO)
	wave_tween.tween_property(cardslots,"position",Vector2(425,300),1)
	wave_tween.tween_property(cardslots,"position",Vector2(-300,300),.75)
	await wave_tween.finished
	audio_stream_player.stream = SPLASH_2
	audio_stream_player.play()
	var reset = create_tween()
	reset.tween_property(cardslots,"position",Vector2(0,0),.5)


func display_values():
	var text_tween = create_tween()
	text_tween.set_parallel()
	text_tween.tween_property(playervalues,"visible_ratio",1,1)
	text_tween.tween_property(opponentvalues,"visible_ratio",1,1)
	await  text_tween.finished
	



func player_wave_animation(cardslots: Node2D):
	audio_stream_player.stream = SPLASH_1
	audio_stream_player.play()
	var wave_tween = create_tween()
	wave_tween.set_ease(Tween.EASE_OUT)
	wave_tween.set_trans(Tween.TRANS_EXPO)
	
	wave_tween.tween_property(cardslots,"position",Vector2(-350,-300),1)
	
	
	wave_tween.tween_property(cardslots,"position",Vector2(350,-300),.75)
	await wave_tween.finished
	audio_stream_player.stream = SPLASH_2
	audio_stream_player.play()
	var reset = create_tween()
	reset.tween_property(cardslots,"position",Vector2(0,0),.5)

func reset_board():
	for i in range(3):
		deck.deck.push_back(playercardslots.get_children()[i].card_in_slot.value)
		deck.deck.push_back(opponentcardslots.get_children()[i].card_in_slot.value)
		playercardslots.get_children()[i].card_in_slot.queue_free()
		opponentcardslots.get_children()[i].card_in_slot.queue_free()
		opponent_timer.start()
		
		await  opponent_timer.timeout
	$"../Button".disabled = false
	playervalues.visible_ratio =0.0
	opponentvalues.visible_ratio = 0.0
	audio_stream_player.stream = CARD_FAN_1
	audio_stream_player.play()
	deck.round_draw()
	await audio_stream_player.finished
	oppnents_move()
	
func inflict_Damage_To_Player(damage : int):
	current_health = current_health - damage
	if current_health < 0:
		current_health = 0
		lose_game()
	health.text = str(current_health)
func inflict_Damage_To_Opponent(damage : int):
	opponent_current_health = opponent_current_health - damage
	if opponent_current_health < 0:
		win_game()
		opponent_current_health = 0
	opponent_health.text = str(opponent_current_health)

func lose_game():
	game_end = true
	gameovertext.text = "YOU LOSE"
	get_parent().lost_minigame.emit()
	display_game_over()

func win_game():
	game_end = true
	get_parent().won_minigame.emit()
	gameovertext.text = "YOU WIN"
	display_game_over()
	
func display_game_over():
	var gameover_tween = create_tween()
	gameover_tween.set_ease(Tween.EASE_IN_OUT)
	gameover_tween.set_trans(Tween.TRANS_EXPO)
	gameover_tween.tween_property(gameover,"position",Vector2(405,212),1)

func _on_replay_pressed() -> void:
	await remove_game_over()
	game_end = false
	
	reset_game()

func reset_game():
	current_health = 100
	health.text = str(current_health)
	opponent_current_health = 100
	opponent_health.text = str(opponent_current_health)
	reset_board()



func remove_game_over():
	var gameover_tween = create_tween()
	gameover_tween.set_ease(Tween.EASE_IN_OUT)
	gameover_tween.set_trans(Tween.TRANS_EXPO)
	gameover_tween.tween_property(gameover,"position",Vector2(405,720),1)
	await gameover_tween.finished
