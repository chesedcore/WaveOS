extends Minigame
@onready var ballpathway: StaticBody2D = $ballpathway
@onready var pathwaycollison: CollisionShape2D = $ballpathway/CollisionShape2D

func _on_disable_body_entered(body: Node2D) -> void:
	ballpathway.visible = false
	pathwaycollison.set_deferred("disabled",true)
	
	
	
func _on_enable_body_entered(body: Node2D) -> void:
	ballpathway.visible = true
	pathwaycollison.set_deferred("disabled",false)
