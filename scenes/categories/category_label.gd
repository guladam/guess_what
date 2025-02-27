extends Panel

@export var text: String:
	set(value):
		text = value
		$Label.text = value
