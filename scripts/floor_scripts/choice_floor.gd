extends Node2D

signal setup_finished()

@onready var choices := {
	"A": $A,
	"B": $B,
	"C": $C,
	"D": $D
}

var question: String
var correct_answer: int
var options: Array

func setup_question(data: Dictionary) -> void:
	question = data["question"]
	options = data["choices"]
	correct_answer = data["answer"]
	
	setup_finished.emit()

func _on_choice_selected(selected_id: int) -> void:
	if selected_id == correct_answer:
		global.announce_status("CORRECT")
		global.add_score()
	else:
		global.announce_status("WRONG")
		global.reduce_life()
	
	global.num_of_submit += 1
	global.is_finished_level()
	
	for choice in choices.values():
		choice.disable_door()


func _on_chunk_area_body_entered(body: Node2D) -> void:
	get_tree().get_first_node_in_group("ui").show_dialog(question)
	
func _on_chunk_area_body_exited(body: Node2D) -> void:
	if get_tree().get_first_node_in_group("ui"):
		get_tree().get_first_node_in_group("ui").hide_dialog()

func _on_setup_finished() -> void:
	var ctr: int = 0
	for choice in choices.values():
		choice.id = ctr
		choice.choice_value = options[ctr]
		choice.selected.connect(_on_choice_selected)
		
		ctr += 1
