extends TileMapLayer

func _ready() -> void:
	#show_tile_debug()
	spawn_tiles()

var use_arr: Array[Vector2i]:
	get:
		var arr: Array[Vector2i] = []
		for i in 17: for j in 8:
			arr.push_back(Vector2i(i,j))
		return arr

func spawn_tiles() -> void:
	var tile_preload: PackedScene = preload("res://scenes/tile.tscn")
	for tile: Vector2i in use_arr:
		var tile_node: Node2D = tile_preload.instantiate()
		add_child(tile_node)
		tile_node.position = map_to_local(tile)

func show_tile_debug() -> void:
	print(get_used_cells())
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
