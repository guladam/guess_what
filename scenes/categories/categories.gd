class_name Categories
extends HBoxContainer

enum Mode {
	EDIT,
	READ
}

const CATEGORY_EDIT = preload("res://scenes/categories/category_edit.tscn")
const CATEGORY_LABEL = preload("res://scenes/categories/category_label.tscn")

@export var mode: Mode
@export var game_settings: GameSettings: set = set_game_settings


func get_categories() -> Array[String]:
	var categories: Array[String] = []
	
	for child: Node in get_children():
		categories.append(child.text)
	
	return categories


func add_categories(n: int) -> void:
	for _i in range(n):
		_add_category()


func delete_categories(n: int) -> void:
	for i in range(1, n+1):
		get_child(-i).queue_free()


func set_game_settings(new_value: GameSettings) -> void:
	game_settings = new_value
	
	if not is_node_ready():
		await ready
	
	for child: Node in get_children():
		child.queue_free()
	
	for i in game_settings.columns:
		_add_category(game_settings.categories[i])


func _add_category(text: String = "") -> Node:
	var new_child := _create_child_node()
	new_child.text = text
	
	if new_child is LineEdit:
		var placeholder: String = tr("GE_CAT_TITLE") % str(get_child_count() + 1)
		new_child.placeholder_text = placeholder
	
	add_child(new_child)
	
	return new_child


func _create_child_node() -> Node:
	match mode:
		Mode.EDIT:
			return CATEGORY_EDIT.instantiate()
		Mode.READ:
			return CATEGORY_LABEL.instantiate()
	
	return null
