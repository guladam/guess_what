extends Button

@export var language_icons: Array[Texture]

@onready var language_icon: TextureRect = $MarginContainer/LanguageIcon

var idx: int
var languages: PackedStringArray

func _ready() -> void:
	languages = TranslationServer.get_loaded_locales()
	idx = languages.find(TranslationServer.get_locale())
	language_icon.texture = language_icons[idx]
	
	pressed.connect(
		func() -> void:
			idx = wrapi(idx+1, 0, languages.size())
			TranslationServer.set_locale(languages[idx])
			language_icon.texture = language_icons[idx]
	)
