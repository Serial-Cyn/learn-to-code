extends Area2D

@onready var answer_sheet: Window = $AnswerSheet
@onready var answer_field: LineEdit = $AnswerSheet/CameraWindow/AnswerField
@onready var choice_name: Label = $ChoiceName

signal submitted(answer: String)

var is_in_interaction_zone: bool = false
var is_interacted: bool = false
var answer: String

func _ready() -> void:
	choice_name.visible = false
	answer_sheet.hide()

func _process(delta: float) -> void:
	if not is_in_interaction_zone:
		return
	
	if is_interacted:
		return
		
	if Input.is_action_just_pressed("interact"):
		global.can_move = false
		answer_sheet.show()

func _on_body_entered(body: Node2D) -> void:
	choice_name.visible = true
	is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	choice_name.visible = false
	is_in_interaction_zone = false

func _on_submit_btn_button_down() -> void:
	global.can_move = true
	answer = answer_field.text.to_lower()
	answer_sheet.hide()
	
	# Emit to notify listening nodes to process the answer
	is_interacted = true
	submitted.emit(answer)

func _on_close_btn_button_down() -> void:
	global.can_move = true
	answer_sheet.hide()

func _on_answer_sheet_close_requested() -> void:
	global.can_move = true
	answer_sheet.hide()
