extends Node

# Remark: Due to async requirements, this uses messaging model. Instead of using simple return values and set image texture directly within calls, we rely on internal state variables for holding return value and an explicit call back function to finish the request.

# Request handling state
var _loaded_image:Image = null

# Routines
func _load_image(address:String):
	if address.find("http") == 0:
		_load_from_http(address)
	else: 
		_load_from_file(address)

func _load_from_http(address):
	var request:HTTPRequest = HTTPRequest.new()
	get_node(".").add_child(request)
	request.request_completed.connect(_on_request_completed)
	request.request(address)

func _on_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_jpg_from_buffer(body) # Assuming jpg; This part is tricky - we need to figure out the right file type otherwise this function will cause error
	if error != OK:
		push_error("Couldn't load the image.")
		
	_loaded_image = image
	_on_image_loaded()

func _load_from_file(file_path:String):
	_loaded_image = Image.load_from_file(file_path)
	_on_image_loaded()

# Signals
func _on_button_pressed():
	var address:String = %AddressText.text
	_load_image(address)

# Callbacks
func _on_image_loaded():
	var image:Image = _loaded_image
	%TextureRect.texture = ImageTexture.create_from_image(image)
