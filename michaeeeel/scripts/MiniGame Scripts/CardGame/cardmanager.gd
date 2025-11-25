class_name CardManager
extends Node2D

const  COLL_MASK_CARD =1
const  COLL_MASK_CARDSLOT =2
const  CARD_DEFUALT_SIZE = Vector2(1.5,1.5)
const CARD_HIGHLIGHT_SIZE = Vector2(1.75,1.75)
var card_being_dragged : Card
var screen_size

var is_hovering_on_card = false

func  _ready() -> void:
	screen_size = get_viewport_rect().size
	

func connect_card_signals(card : Card):
	card.hovered_on.connect(on_hovered)
	card.hovered_off.connect(on_hovered_off)

func on_hovered(card :Card):
	if ! is_hovering_on_card :
		is_hovering_on_card = true
		highlight_Card(card,true)
	
func on_hovered_off(card :Card):
	if !card_being_dragged:
		highlight_Card(card,false)
		var new_card = raycast_check_for_card()
		if new_card:
			highlight_Card(new_card,true)
		else:
			is_hovering_on_card = false

func highlight_Card(card: Card,hovered:bool):
	if hovered  :
		
		var tween = create_tween()
		tween.tween_property(card,"scale",CARD_HIGHLIGHT_SIZE,0.25)
		card.z_index = 2
	else:
		var tween = create_tween()
		tween.tween_property(card,"scale",CARD_DEFUALT_SIZE,0.25)
		card.z_index = 1



func raycast_check_for_card() ->Card:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLL_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		
		return  get_card_with_highest_z_index(result)
	return null



func raycast_check_for_cardslot() :
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLL_MASK_CARDSLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		
		return  result[0].collider.get_parent()
	return null


func get_card_with_highest_z_index(cards) ->Card:
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1,cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index> highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card



func  _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		
		card_being_dragged.position = mouse_pos
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),clamp(mouse_pos.y,0,screen_size.y))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				start_drag(card)
		else :
			if card_being_dragged:
				finish_drag()
			
			
			
func start_drag(card:Card):
	card_being_dragged = card
	card.scale = CARD_DEFUALT_SIZE
func finish_drag():
	card_being_dragged.scale = CARD_HIGHLIGHT_SIZE
	var card_slot_found  = raycast_check_for_cardslot()
	if card_slot_found:
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
	card_being_dragged = null
	
