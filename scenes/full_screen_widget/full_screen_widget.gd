extends CanvasLayer

var fullscreen := true :
	set(value):
		fullscreen = value
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _ready() -> void:
	$FullScreenButton.pressed.connect(func(): fullscreen = not fullscreen)
