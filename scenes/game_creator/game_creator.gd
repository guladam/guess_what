extends Control


func _ready() -> void:
	var game_editor := SceneChanger.GAME_EDITOR.instantiate() as GameEditor
	add_child(game_editor)
	
	# this is needed so placeholder children can be deleted
	await get_tree().process_frame
	game_editor.game_grid.spawn_questions()
