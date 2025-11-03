extends TileMapLayer

func _ready() -> void:
	for tile: Vector2i in get_used_cells():
		var centering_cont := CenterContainer.new()
		var label := RichTextLabel.new()
		centering_cont.use_top_left = true
		add_child(centering_cont)
		centering_cont.add_child(label)
		label.fit_content = true
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		var target_position := map_to_local(tile)
		label.set_text(str(tile))
		centering_cont.position = target_position
		centering_cont.scale *= 0.7
