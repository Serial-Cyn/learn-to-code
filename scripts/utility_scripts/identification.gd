extends Area2D

@onready var answer_sheet: Window = $AnswerSheet
@onready var answer_field: LineEdit = $AnswerSheet/CameraWindow/AnswerField

signal submitted(answer: String)

var is_in_interaction_zone: bool = false
var answer: String

func _ready() -> void:
	answer_sheet.hide()

func _process(delta: float) -> void:
	if not is_in_interaction_zone:
		return
		
	if Input.is_action_just_pressed("interact"):
		answer_sheet.show()

func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false

func _on_submit_btn_button_down() -> void:
	answer_sheet.hide()
	answer = answer_field.text
	
	# Emit to notify listening nodes to process the answer
	submitted.emit(answer)

func _on_close_btn_button_down() -> void:
	answer_sheet.hide()

func _on_answer_sheet_close_requested() -> void:
	answer_sheet.hide()
