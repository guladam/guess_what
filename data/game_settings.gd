class_name GameSettings
extends Resource

@export_category("Base Data")
@export var game_name: String: set = set_game_name
@export var rows: int: set = set_rows
@export var columns: int: set = set_columns
@export var starting_money: int: set = set_starting_money
@export var increments: int: set = set_increments
@export var currency: String: set = set_currency

@export_category("Questions")
@export var questions: Array[Question] = []
@export var categories: Array[String] = []


func set_game_name(value: String) -> void:
	game_name = value
	emit_changed()


func set_rows(value: int) -> void:
	rows = value
	questions.resize(rows * columns)
	emit_changed()


func set_columns(value: int) -> void:
	columns = value
	questions.resize(rows * columns)
	categories.resize(columns)
	emit_changed()


func set_starting_money(value: int) -> void:
	starting_money = value
	emit_changed()


func set_increments(value: int) -> void:
	increments = value
	emit_changed()


func set_currency(value: String) -> void:
	currency = value
	emit_changed()


func get_question(idx: Vector2i) -> Question:
	var question_index := idx.x * columns + idx.y
	
	if not questions[question_index]:
		questions[question_index] = Question.new()
		
	return questions[question_index]
