class_name QuestionEditDialog
extends ConfirmationDialog

@export var question: Question: set = set_question

@onready var tab_container: TabContainer = $TabContainer
@onready var time_limit_spin_box: SpinBox = %TimeLimitSpinBox
@onready var question_text_edit: TextEdit = %QuestionTextEdit
@onready var image_preview: TextureRect = %ImagePreview
@onready var image_icon: TextureRect = %ImageIcon
@onready var answer_text_edit: TextEdit = %AnswerTextEdit

# NOTE this node requires a question resource set to work properly
func _ready() -> void:
	get_tree().root.files_dropped.connect(_on_files_dropped)
	confirmed.connect(_save_question)
	
	tab_container.set_tab_title(0, "GE_QUESTION_TAB")
	tab_container.set_tab_title(1, "GE_IMG_TAB")
	tab_container.set_tab_title(2, "GE_ANSWER_TAB")


func show_dialog() -> void:
	show()
	tab_container.current_tab = 0


func set_question(new_value: Question) -> void:
	if not is_node_ready():
		await ready
	
	question = new_value
	
	time_limit_spin_box.value = question.time_limit
	question_text_edit.text = question.text
	answer_text_edit.text = question.answer
	if question.has_image():
		_set_question_image(question.image_path)
	else:
		image_icon.show()
		image_preview.hide()


func _save_question() -> void:
	question.text = question_text_edit.text.strip_edges()
	question.time_limit = int(time_limit_spin_box.value)
	question.answer = answer_text_edit.text.strip_edges()


func _set_question_image(path: String) -> void:
	var texture := Util.load_image_from_path(path)
	image_preview.texture = texture
	image_preview.show()
	image_icon.hide()


func _on_files_dropped(files: PackedStringArray) -> void:
	if not visible:
		return
	
	if Util.is_path_valid_image(files[0]):
		_set_question_image(files[0])
		question.image_path = files[0]
