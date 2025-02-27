class_name Question
extends Resource

@export var time_limit: int
@export var text: String
@export var image_path: String
@export var answer: String


func has_time_limit() -> bool:
	return time_limit > 0


func has_image() -> bool:
	return len(image_path) > 0 and Util.is_path_valid_image(image_path)


func _to_string() -> String:
	return "Question: %s\nTime limit: %s seconds\nAnswer: %s\nImage path: %s" % [
		text,
		time_limit,
		answer,
		image_path
	]
