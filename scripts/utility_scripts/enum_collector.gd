extends Area2D

signal submitted(result: bool)

var collected_answers: Array
var expected_answers: Array
var is_in_interaction_zone: bool = false

func _process(delta: float) -> void:
	if expected_answers.is_empty():
		return # Node is not yet confifured
	
	if is_in_interaction_zone and Input.is_action_just_pressed("interact"):
	
		if collected_answers.is_empty():
			return # No answers to process
		
		# collected answers must match the number of expected answers, otherwise it is wrong
		if collected_answers.size() != expected_answers.size():
			return
		
		var are_answers_same = true
		for answer in collected_answers:
			if expected_answers.has(answer):
				continue
			else:
				are_answers_same = false
				
				break # End loop because one or more of the answers are wrong
		
		if are_answers_same:
			submitted.emit(true) # Answers are correct
		else:
			submitted.emit(false) # Answers are wrong

func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false

func set_expected_answers(answers: Array):
	expected_answers = answers

func populate_collector(answers: Array):
	collected_answers = answers
