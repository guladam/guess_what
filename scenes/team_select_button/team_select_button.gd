extends Button

@export var team_icon: Texture: 
	set(value):
		team_icon = value
		%Icon.texture = team_icon
