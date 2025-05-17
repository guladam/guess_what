extends Control

@onready var file_dialog: FileDialog = $FileDialog


func _ready() -> void:
	file_dialog.file_selected.connect(_on_file_selected)
	file_dialog.canceled.connect(file_dialog.queue_free)
	file_dialog.tree_exited.connect(_on_file_dialog_tree_exited)
	file_dialog.show()


func _on_file_selected(path: String) -> void:
	assert(path.ends_with(".tres"), "Wrong file!")
	
	var game_settings: GameSettings = ResourceLoader.load(path, "GameSettings")
	assert(game_settings, "Game couldn't be loaded!")
	
	var game_editor := SceneChanger.GAME_EDITOR.instantiate() as GameEditor
	game_editor.game_settings = game_settings
	add_child(game_editor)
	
	# this is needed so placeholder children can be deleted
	await get_tree().process_frame
	
	game_editor.categories.game_settings = game_settings
	game_editor.game_grid.game_settings = game_settings
	game_editor.game_grid.spawn_questions()
	game_editor.game_name.text = game_settings.game_name
	game_editor.starting_money_spin_box.value = game_settings.starting_money
	game_editor.increment_spin_box.value = game_settings.increments
	game_editor.rows_spin_box.value = game_settings.rows
	game_editor.columns_spin_box.value = game_settings.columns
	Util.select_option_button_by_text(game_editor.currency, game_settings.currency)


func _on_file_dialog_tree_exited() -> void:
	if not is_inside_tree():
		return
	
	SceneChanger.change_scene_to_packed(SceneChanger.MENU)
