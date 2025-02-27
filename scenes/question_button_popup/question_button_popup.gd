class_name QuestionButtonPopup
extends PanelContainer

@export var offset: Vector2

@onready var question_text_label: Label = %QuestionTextLabel


func popup(question: Question) -> void:
	if not question:
		return

	if len(question.text.strip_edges()) == 0:
		return
	
	question_text_label.text = question.text
	show()
