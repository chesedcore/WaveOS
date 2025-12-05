class_name NextDayButton extends Button

func _ready() -> void:
	self.hide()
	Gamestate.day_one_sequence_finished.connect(show)


func _on_pressed() -> void:
	self.hide()
	Bus.end_day_one.emit()
