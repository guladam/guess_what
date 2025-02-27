class_name QuestionPopup
extends PanelContainer

signal question_closed

@export var timer: Timer
@export var question: Question

@onready var question_label: Label = %QuestionLabel
@onready var question_image: TextureRect = %QuestionImage
@onready var time_label: Label = %TimeLabel
@onready var skip_button: Button = %SkipButton
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	skip_button.pressed.connect(reveal_answer)
	time_label.gui_input.connect(_on_time_label_gui_input)
	timer.timeout.connect(reveal_answer)
	continue_button.pressed.connect(_on_continue_button_pressed)


func _process(_delta: float) -> void:
	if not visible or not timer.time_left > 0 or timer.paused:
		return
	
	time_label.text = str(int(timer.time_left))


func setup_question() -> void:
	question_label.text = question.text
	question_image.hide()
	
	if question.has_image():
		var texture := Util.load_image_from_path(question.image_path)
		question_image.texture = texture
		question_image.show()
	
	if question.time_limit > 0:
		timer.wait_time = question.time_limit
		time_label.text = str(question.time_limit)
		time_label.show()
		await get_tree().create_timer(1).timeout
		timer.start()
	else:
		time_label.hide()


func reveal_answer() -> void:
	# Already revealed
	if continue_button.visible:
		return
	
	question_label.text = question.answer
	skip_button.disabled = true
	timer.stop()
	timer.paused = false
	time_label.text = "0"
	continue_button.show()


func _toggle_timer() -> void:
	if is_equal_approx(timer.time_left, 0.0):
		return
	
	timer.paused = not timer.paused
	var alpha := 0.35 if timer.paused else 1.0
	time_label.modulate.a = alpha


func _on_time_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_toggle_timer()


func _on_continue_button_pressed() -> void:
	continue_button.hide()
	skip_button.disabled = false
	question_closed.emit()
	hide()
