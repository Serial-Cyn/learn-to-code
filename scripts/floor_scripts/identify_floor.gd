extends Node2D

@onready var identification: Area2D = $Identification

var question: String
var correct_answer: String
var options: Array

func setup_question(data: Dictionary) -> void:
	question = data["question"]
	correct_answer = data["answer"]


func _on_chunk_area_body_entered(body: Node2D) -> void:
	get_tree().get_first_node_in_group("ui").show_dialog(question)

func _on_chunk_area_body_exited(body: Node2D) -> void:
	if get_tree().get_first_node_in_group("ui"):
		get_tree().get_first_node_in_group("ui").hide_dialog()

func _on_identification_submitted(answer: String) -> void:
	if answer == correct_answer:
		global.announce_status("CORRECT")
	else:
		global.announce_status("WRONG")
