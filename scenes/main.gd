extends Node

# Routines
func _load_image(address:String) -> Image:
	return _load_from_file(address)
	
func _load_from_file(file_path:String) -> Image:
	return Image.load_from_file(file_path)

# Signals
func _on_button_pressed():
	var address:String = %AddressText.text
	var image:Image = _load_image(address)
	%TextureRect.texture = ImageTexture.create_from_image(image)
