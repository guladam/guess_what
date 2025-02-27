class_name Game
extends Resource

@export_range(2, 10) var teams: int: set = set_teams
@export var icons: Array[Texture] = []


func set_teams(value: int) -> void:
	teams = value
	icons.resize(teams)
	emit_changed()
