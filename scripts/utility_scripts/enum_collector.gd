extends Area2D

signal submitted(correct: bool)

@onready var instruction_label: Label = $InstructionLabel
@onready var sprite: AnimatedSprite2D = $Sprite

@export var submit_hold_time := 1.0 # seconds required to submit

var hold_timer := 0.0
var is_holding := false
var hold_progress := hold_timer / submit_hold_time

var collected_answers: Array = []
var expected_answers: Array = []

var is_in_interaction_zone := false
var can_submit := false

func _ready() -> void:
	sprite.play("default")

func _process(delta: float) -> void:
	instruction_label.visible = false # default state

	if expected_answers.is_empty():
		reset_hold()
		return

	if not is_in_interaction_zone:
		reset_hold()
		return
	
	if global.item:
		instruction_label.text = "Press 'E' to place answer"
		instruction_label.visible = true
		
		reset_hold()
		return

	if not can_submit:
		reset_hold()
		return

	# Player can submit
	instruction_label.visible = true

	if Input.is_action_pressed("interact"):
		is_holding = true
		hold_timer += delta

		hold_progress = hold_timer / submit_hold_time
		instruction_label.modulate = Color(1, 1 - hold_progress, 1 - hold_progress)
		instruction_label.text = "Submitting: " + str(int(hold_progress * 100)) + "%"

		if hold_timer >= submit_hold_time:
			submit_answers()
			reset_hold()
	else:
		instruction_label.text = "Hold 'E' to Submit"
		instruction_label.modulate = Color(1, 1, 1)
		reset_hold()

func submit_answers() -> void:
	if collected_answers.size() != expected_answers.size():
		sprite.play("wrong")
		submitted.emit(false)
		can_submit = false
		return

	for answer in collected_answers:
		if answer not in expected_answers:
			sprite.play("wrong")
			submitted.emit(false)
			can_submit = false
			return

	sprite.play("correct")
	submitted.emit(true)
	can_submit = false
	
func reset_hold() -> void:
	hold_timer = 0.0
	is_holding = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_interaction_zone = false

func set_expected_answers(answers: Array) -> void:
	expected_answers = answers
	can_submit = true # Explicitly allow submission

func populate_collector(answers: Array) -> void:
	collected_answers = answers

func _on_drop_zone_area_entered(area: Area2D) -> void:
	if area.value in collected_answers:
		return # prevent duplicates

	collected_answers.append(area.value)
	area.queue_free()
