class_name GameEditor
extends Control

@export var game_settings: GameSettings

@onready var save_button: Button = %SaveButton
@onready var exit_button: Button = %ExitButton
@onready var game_name: LineEdit = %GameName
@onready var rows_spin_box: SpinBox = %RowsSpinBox
@onready var columns_spin_box: SpinBox = %ColumnsSpinBox
@onready var starting_money_spin_box: SpinBox = %StartingMoneySpinBox
@onready var currency: OptionButton = %Currency
@onready var increment_spin_box: SpinBox = %IncrementSpinBox
@onready var categories: Categories = %Categories
@onready var game_grid: GameGrid = %GameGrid
@onready var question_edit_dialog: QuestionEditDialog = $QuestionEditDialog
@onready var save_file_dialog: FileDialog = $SaveFileDialog
@onready var saved_accept_dialog: AcceptDialog = $SavedAcceptDialog
@onready var question_button_popup: QuestionButtonPopup = %QuestionButtonPopup


func _ready() -> void:
	save_button.pressed.connect(save_file_dialog.show)
	exit_button.pressed.connect(SceneChanger.change_scene_to_packed.bind(SceneChanger.MENU))
	game_name.text_changed.connect(game_settings.set_game_name)
	rows_spin_box.value_changed.connect(_on_rows_spinbox_changed)
	columns_spin_box.value_changed.connect(_on_columns_spinbox_changed)
	starting_money_spin_box.value_changed.connect(_on_starting_money_spinbox_changed)
	currency.item_selected.connect(_on_currency_item_selected)
	increment_spin_box.value_changed.connect(_on_increments_spinbox_changed)
	game_grid.question_pressed.connect(_on_question_pressed)
	game_grid.question_mouse_entered.connect(_on_question_mouse_entered)
	game_grid.question_mouse_exited.connect(_on_question_mouse_exited)
	save_file_dialog.file_selected.connect(_on_save_dialog_file_selected)
	saved_accept_dialog.confirmed.connect(_on_save_accecpt_dialog_closed)
	saved_accept_dialog.canceled.connect(_on_save_accecpt_dialog_closed)


func _on_rows_spinbox_changed(new_value: float) -> void:
	var change := int(new_value) - game_settings.rows
	game_settings.rows = int(new_value)
	
	if change >= 1:
		game_grid.add_rows(change)
	else:
		game_grid.delete_rows(abs(change))


func _on_columns_spinbox_changed(new_value: float) -> void:
	var change := int(new_value) - game_settings.columns
	game_settings.columns = int(new_value)
	
	if change >= 1:
		game_grid.add_columns(change)
		categories.add_categories(change)
	else:
		game_grid.delete_columns(abs(change))
		categories.delete_categories(abs(change))


func _on_starting_money_spinbox_changed(new_value: float) -> void:
	game_settings.starting_money = int(new_value)
	game_grid.update_questions()


func _on_currency_item_selected(idx: int) -> void:
	game_settings.currency = currency.get_item_text(idx)
	game_grid.update_questions()


func _on_increments_spinbox_changed(new_value: float) -> void:
	game_settings.increments = int(new_value)
	game_grid.update_questions()


func _on_question_pressed(idx: Vector2i) -> void:
	question_edit_dialog.question = game_settings.get_question(idx)
	question_edit_dialog.show_dialog()


func _on_question_mouse_entered(idx: Vector2i, button: Button) -> void:
	question_button_popup.global_position = button.global_position + question_button_popup.offset
	question_button_popup.popup(game_settings.get_question(idx))


func _on_question_mouse_exited() -> void:
	question_button_popup.hide()


func _on_save_dialog_file_selected(path: String) -> void:
	if not path.ends_with(".tres"):
		path += ".tres"
	
	game_settings.categories = categories.get_categories()
	var err := ResourceSaver.save(game_settings, path)
	assert(err == OK, "Game couldn't be saved!")
	
	saved_accept_dialog.show()


func _on_save_accecpt_dialog_closed() -> void:
	SceneChanger.change_scene_to_packed(SceneChanger.MENU)
