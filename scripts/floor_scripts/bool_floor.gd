extends Node2D

signal setup_finished()

@onready var choices := {
	"False": $False,
	"True": $True
}

var question: String
var correct_answer: int
var options: Array

func setup_question(data: Dictionary) -> void:
	question = data["question"]
	correct_answer = data["answer"]
	
	setup_finished.emit()


func _on_chunk_area_body_entered(body: Node2D) -> void:
	get_tree().get_first_node_in_group("ui").show_dialog(question)

func _on_chunk_area_body_exited(body: Node2D) -> void:
	if get_tree().get_first_node_in_group("ui"):
		get_tree().get_first_node_in_group("ui").hide_dialog()

func _on_setup_finished() -> void:
	var ctr: int = 1
	for choice in choices.values():
		choice.state = ctr
		if ctr == 1:
			choice.choice_value = "TRUE"
		else:
			choice.choice_value = "FALSE"
		choice.selected.connect(_on_choice_selected)
		
		ctr -= 1

func _on_choice_selected(selected_state: int) -> void:
	if selected_state == correct_answer:
		global.announce_status("CORRECT")
		global.add_score()
	else:
		global.announce_status("WRONG")
		global.reduce_life()
	
	global.num_of_submit += 1
	global.is_finished_level()
	
	for choice in choices.values():
		choice.disable_door()
