class_name GameGrid
extends GridContainer

signal question_pressed(coordinate: Vector2i)
signal question_mouse_entered(coordinate: Vector2i, button: Button)
signal question_mouse_exited

const QUESTION_BUTTON = preload("res://scenes/question_button/question_button.tscn")

@export var game_settings: GameSettings:
	set(value):
		game_settings = value
		game_settings.changed.connect(_on_game_settings_changed)


func _ready() -> void:
	for child: Node in get_children():
		child.queue_free()


func spawn_questions() -> void:
	_add_n_children(game_settings.columns * game_settings.rows)


func add_columns(n: int) -> void:
	_add_n_children(n * game_settings.rows)


func delete_columns(n: int) -> void:
	_delete_n_children(n * game_settings.rows)


func add_rows(n: int) -> void:
	_add_n_children(n * game_settings.columns)


func delete_rows(n: int) -> void:
	_delete_n_children(n * game_settings.columns)


func update_questions() -> void:
	for i: int in game_settings.rows:
		for j: int in game_settings.columns:
			var button := get_child(i * game_settings.columns + j) as Button
			button.text = _get_money_text(i)
			_setup_button_connections(button, i, j)


func _delete_n_children(n: int) -> void:
	for i: int in n:
		get_child(i).queue_free()
		
		if i == n - 1:
			get_child(i).tree_exited.connect(update_questions, CONNECT_ONE_SHOT)


func _add_n_children(n: int) -> void:
	for i: int in n:
		var new_question := QUESTION_BUTTON.instantiate()
		add_child(new_question)
	
	update_questions()


func _get_money_text(i: int) -> String:
	var money := game_settings.starting_money + (game_settings.increments * i)
	return str(money) + " " + game_settings.currency


func _setup_button_connections(button: Button, i: int, j: int) -> void:
		if button.pressed.is_connected(_on_question_button_pressed):
			button.pressed.disconnect(_on_question_button_pressed)
		
		if button.mouse_entered.is_connected(_on_question_button_mouse_entered):
			button.mouse_entered.disconnect(_on_question_button_mouse_entered)
		
		if button.mouse_exited.is_connected(_on_question_button_mouse_exited):
			button.mouse_exited.disconnect(_on_question_button_mouse_exited)

		button.pressed.connect(_on_question_button_pressed.bind(i, j))
		button.mouse_entered.connect(_on_question_button_mouse_entered.bind(i, j, button))
		button.mouse_exited.connect(_on_question_button_mouse_exited)


func _on_game_settings_changed() -> void:
	self.columns = game_settings.columns

func _on_question_button_pressed(i: int, j: int) -> void:
	question_pressed.emit(Vector2i(i, j))


func _on_question_button_mouse_entered(i: int, j: int, button: Button) -> void:
	question_mouse_entered.emit(Vector2i(i, j), button)


func _on_question_button_mouse_exited() -> void:
	question_mouse_exited.emit()
