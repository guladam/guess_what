extends Control

@export var game: Game
@export var game_settings: GameSettings

@onready var exit_button: Button = %ExitButton
@onready var team_selector: TeamSelector = $TeamSelector
@onready var game_screen: GameScreen = $GameScreen
@onready var file_dialog: FileDialog = $FileDialog
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog


func _ready() -> void:
	exit_button.pressed.connect(confirmation_dialog.show)
	
	team_selector.team_setup_completed.connect(
		func() -> void:
			file_dialog.show()
	)
	
	file_dialog.file_selected.connect(
		func(path: String) -> void:
			assert(path.ends_with(".tres"), "Wrong file!")
			
			game_settings = ResourceLoader.load(path, "GameSettings")
			assert(game_settings, "Game couldn't be loaded!")
			
			team_selector.hide()
			game_screen.show()
			game_screen.start_game(game, game_settings)
	)
	
	confirmation_dialog.confirmed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.MENU))
