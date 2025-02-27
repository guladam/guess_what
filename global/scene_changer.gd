extends Node

const MENU = preload("res://scenes/menu/menu.tscn")
const GAME_STARTER = preload("res://scenes/game_starter/game_starter.tscn")
const GAME_CREATOR = preload("res://scenes/game_creator/game_creator.tscn")
const GAME_EDITOR = preload("res://scenes/game_editor/game_editor.tscn")
const GAME_LOADER = preload("res://scenes/game_loader/game_loader.tscn")


func change_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)


func change_scene_to_packed(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)
