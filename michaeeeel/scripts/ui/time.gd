class_name TaskTime extends RichTextLabel

@export var timer: Timer

func _update_time() -> void:
	var now := Time.get_datetime_dict_from_system()
	self.text = str(now["hour"]) + ":" + str(now["minute"]) + ":" + str(now["second"])
	Data.systime = self.text

func _ready() -> void:
	timer.timeout.connect(_update_time)
	_update_time()
