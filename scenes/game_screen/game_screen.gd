class_name GameScreen
extends Control

const TEAM_CONTAINER = preload("res://scenes/team_container/team_container.tscn")

@onready var game_name_label: Label = %GameNameLabel
@onready var categories: Categories = %Categories
@onready var game_grid: GameGrid = %GameGrid
@onready var teams: HBoxContainer = %Teams
@onready var question_popup: QuestionPopup = $QuestionPopup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_idx: Vector2i


func start_game(game: Game, game_settings: GameSettings) -> void:
	game_name_label.text = game_settings.game_name
	categories.game_settings = game_settings
	game_grid.game_settings = game_settings
	game_grid.columns = game_settings.columns
	game_grid.spawn_questions()
	game_grid.question_pressed.connect(_on_question_pressed)
	question_popup.question_closed.connect(_on_question_closed)

	for node: Node in teams.get_children():
		node.queue_free()
	
	for i: int in game.teams:
		var container: TeamContainer = TEAM_CONTAINER.instantiate()
		container.game_settings = game_settings
		teams.add_child(container)
		container.team_icon.texture = game.icons[i]
		container.toggle_bottom_buttons(false)
		container.correct_button.pressed.connect(_on_team_bottom_pressed.bind(container, true))
		container.incorrect_button.pressed.connect(_on_team_bottom_pressed.bind(container, false))


func _on_question_pressed(idx: Vector2i) -> void:
	current_idx = idx
	question_popup.question = game_grid.game_settings.get_question(idx)
	question_popup.setup_question()
	animation_player.play("popup")
	await animation_player.animation_finished
	get_tree().call_group("team_containers", "toggle_bottom_buttons", true)


func _on_question_closed() -> void:
	var button_idx := current_idx.x * game_grid.game_settings.columns + current_idx.y
	var button: Button = game_grid.get_child(button_idx)
	button.disabled = true
	button.modulate.a = 0.35


func _on_team_bottom_pressed(team: TeamContainer, correct: bool) -> void:
	question_popup.reveal_answer()
	var change_sign := 1 if correct else -1
	var money := game_grid.game_settings.starting_money + current_idx.x * game_grid.game_settings.increments
	team.change_money(change_sign, money)
	get_tree().call_group("team_containers", "toggle_bottom_buttons", false)
