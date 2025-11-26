class_name  CardInputManager
extends Node2D




const  COLLISION_MASK_CARD = 1
const  COLLISION_MASK_DECK = 4
@onready var cardmanager: CardManager = $"../Cardmanager"



signal  lmb_clicked
signal lmb_released

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index== MOUSE_BUTTON_LEFT:
		if event.pressed:
			lmb_clicked.emit()
			
			raycast_at_cursor()
		else:
			lmb_released.emit()
			
			
			
			

func raycast_at_cursor():
	
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	
	var result = space_state.intersect_point(parameters)
	if result.size()> 0:
		
		var result_collision_mask = result[0].collider.collision_mask
		
		match result_collision_mask:
			COLLISION_MASK_CARD:
				var card_found =  result[0].collider.get_parent()
				if card_found:
					cardmanager.start_drag(card_found)
					
			COLLISION_MASK_DECK:
				var deck = result[0].collider.get_parent()
				
				
				deck.draw_card()
 
