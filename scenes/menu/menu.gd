extends Control

@onready var new_game_button: Button = %NewGameButton
@onready var create_game_button: Button = %CreateGameButton
@onready var edit_game_button: Button = %EditGameButton
@onready var quit_button: Button = %QuitButton
@onready var game_folder_button: Button = %GameFolderButton


func _ready() -> void:
	new_game_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.GAME_STARTER))
	create_game_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.GAME_CREATOR))
	edit_game_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.GAME_LOADER))
	game_folder_button.pressed.connect(_on_game_folder_pressed)
	quit_button.pressed.connect(get_tree().quit)
	
	if not FileAccess.file_exists("user://games"):
		var dir := DirAccess.open("user://")
		dir.make_dir("games")


func _on_game_folder_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir())
