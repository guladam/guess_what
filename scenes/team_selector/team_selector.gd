class_name TeamSelector
extends Control

signal team_setup_completed

@export var game: Game
@export var team_size_button_group: ButtonGroup
@export var team_icon_button_group: ButtonGroup

@onready var team_size_selector: CenterContainer = %TeamSizeSelector
@onready var team_size_next_button: Button = %TeamSizeNextButton
@onready var team_icon_selector: MarginContainer = %TeamIconSelector
@onready var team_icon_select_label: Label = %TeamIconSelectLabel
@onready var team_icon_next_button: Button = %TeamIconNextButton
@onready var load_game_prompt: MarginContainer = %LoadGamePrompt
@onready var load_prompt_button: Button = %LoadPromptButton
@onready var teams_with_icons := 0

func _ready() -> void:
	team_size_next_button.pressed.connect(_on_team_size_next_button_pressed)
	team_icon_next_button.pressed.connect(_on_team_icon_next_button_pressed)
	load_prompt_button.pressed.connect(team_setup_completed.emit)
	team_icon_select_label.text = tr("TS_TEAM_SELECT_SCREEN") % "1"


func _get_first_available_icon() -> Button:
	for button: Button in team_icon_button_group.get_buttons():
		if not button.disabled:
			return button
	
	return null


func _on_team_size_next_button_pressed() -> void:
	game.teams = int(team_size_button_group.get_pressed_button().text)
	team_size_selector.hide()
	team_icon_selector.show()
	team_icon_next_button.show()


func _on_team_icon_next_button_pressed() -> void:
	var selected := team_icon_button_group.get_pressed_button()
	game.icons[teams_with_icons] = selected.team_icon
	teams_with_icons += 1
	
	if teams_with_icons == game.teams:
		team_icon_selector.hide()
		team_icon_next_button.hide()
		load_game_prompt.show()
		return
	
	selected.disabled = true
	selected.modulate.a = 0.35
	_get_first_available_icon().button_pressed = true
	team_icon_select_label.text = tr("TS_TEAM_SELECT_SCREEN") % (teams_with_icons + 1)
