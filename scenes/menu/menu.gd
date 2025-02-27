extends Control

@onready var new_game_button: Button = %NewGameButton
@onready var create_game_button: Button = %CreateGameButton
@onready var edit_game_button: Button = %EditGameButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	new_game_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.GAME_STARTER))
	create_game_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.GAME_CREATOR))
	edit_game_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.GAME_LOADER))
	quit_button.pressed.connect(get_tree().quit)
