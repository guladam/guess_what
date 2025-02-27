extends Node


func is_path_valid_image(path: String) -> bool:
	var file_exists := FileAccess.file_exists(path)
	var is_image := path.ends_with("jpg") or path.ends_with("png")
	
	return file_exists and is_image


func load_image_from_path(path: String) -> ImageTexture:
	if not is_path_valid_image(path):
		return
	
	var image := Image.load_from_file(path)
	assert(image != null, "Image cannot be loaded from: %s" % path)
	
	return ImageTexture.create_from_image(image)


func select_option_button_by_text(option: OptionButton, text: String) -> void:
	var matching := -1
	for i in option.item_count:
		if option.get_item_text(i) == text:
			matching = i
	
	if matching > -1:
		option.select(matching)
