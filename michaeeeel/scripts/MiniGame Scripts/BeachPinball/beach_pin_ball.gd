extends Minigame
@onready var ballpathway: StaticBody2D = $ballpathway
@onready var pathwaycollison: CollisionShape2D = $ballpathway/CollisionShape2D
@onready var score: RichTextLabel = $Sidebar/middlepanel/Score

var current_score = 0

func _on_disable_body_entered(body: Node2D) -> void:
	ballpathway.visible = false
	pathwaycollison.set_deferred("disabled",true)
	
	
	
func _on_enable_body_entered(body: Node2D) -> void:
	ballpathway.visible = true
	pathwaycollison.set_deferred("disabled",false)


func _on_ballspawner_updatescore(points : int) -> void:
	current_score += points
	score.text =  "Score: "+ str(current_score)
