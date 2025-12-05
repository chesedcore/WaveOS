class_name PhotoViewer extends Minigame

@export var image_name: RichTextLabel
@export var image: TextureRect

func configure(img_name: String, texture: Texture) -> void:
	image_name.set_text(img_name)
	image.set_texture(texture)
