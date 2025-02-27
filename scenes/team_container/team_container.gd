class_name TeamContainer
extends VBoxContainer

@export var game_settings: GameSettings

@onready var team_icon: TextureRect = %TeamIcon
@onready var plus_button: Button = %PlusButton
@onready var money_label: Label = %MoneyLabel
@onready var minus_button: Button = %MinusButton
@onready var correct_button: Button = %CorrectButton
@onready var incorrect_button: Button = %IncorrectButton

var money := 0


func _ready() -> void:
	plus_button.pressed.connect(change_money.bind(1))
	minus_button.pressed.connect(change_money.bind(-1))
	
	if game_settings:
		change_money(1, 0)


func change_money(change_sign: int, change: int = game_settings.increments) -> void:
	money += change_sign * change
	money_label.text = "%s %s" % [money, game_settings.currency]


func toggle_bottom_buttons(value: bool) -> void:
	var alpha := 1.0 if value else 0.35
	correct_button.disabled = not value
	incorrect_button.disabled = not value
	correct_button.modulate.a = alpha
	incorrect_button.modulate.a = alpha
