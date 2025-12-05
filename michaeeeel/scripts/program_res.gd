class_name ProgramResource extends Resource

signal visuals_changed

@export var name: String:
	set(val):
		name = val
		visuals_changed.emit()
@export var icon: CompressedTexture2D:
	set(val):
		icon = val
		visuals_changed.emit()
@export_file("*.tscn") var program: String
@export var dupeable: bool = false
