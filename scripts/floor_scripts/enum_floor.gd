extends Node2D

@onready var enum_collector: Area2D = $EnumCollector
@export var choice_template: PackedScene

signal setup_finished

# -----------------------------
# Data
# -----------------------------
var keywords: Array[String] = [
	"Form", "Control", "Property", "Method", "Event", "Procedure",
	"Variable", "Data Type", "Syntax", "Flow Control",
	"If…Then", "If…Then…Else", "Nested If", "Select Case",
	"For…Next Loop", "Do While…Loop", "Do Until…Loop", "While…Wend",
	"TextBox", "Label", "CommandButton", "CheckBox", "OptionButton",
	"ComboBox", "ListBox", "PictureBox", "Image Control",
	"InputBox", "MessageBox", "Menu Editor", "Menu Item", "Submenu",
	"SelStart", "SelLength", "SelText", "Clipboard",
	"PaintPicture Method", "ScaleWidth", "ScaleHeight", "AutoSize"
]

var choices: Array[Node2D] = []
var options: Array[String] = []

var question := ""
var correct_answers: Array = []
var collector_pos: Vector2

var inside_area: bool = false

func _process(delta: float) -> void:
	if not inside_area:
		return
	
	if Input.is_action_just_pressed("reset"):
		enum_collector.collected_answers = []
		
		for choice in choices:
			if is_instance_valid(choice):
				choice.queue_free()
			else:
				choices.erase(choice)
		
		choices.clear()
		spawn_choices()

# -----------------------------
# Question Setup
# -----------------------------
func setup_question(data: Dictionary) -> void:
	question = data.get("question", "")
	correct_answers = data.get("answer", [])

	options.clear()
	options.append_array(correct_answers)

	_add_dummy_options()

	setup_finished.emit()


func _add_dummy_options() -> void:
	var max_dummy := randi_range(1, 2)
	var added := 0

	for keyword in keywords:
		if added >= max_dummy:
			return

		if keyword in correct_answers:
			continue

		options.append(keyword)
		added += 1


# -----------------------------
# Chunk Area Events
# -----------------------------
func _on_chunk_area_body_entered(_body: Node2D) -> void:
	var ui := get_tree().get_first_node_in_group("ui")
	if ui:
		ui.show_dialog(question)
	
	inside_area = true


func _on_chunk_area_body_exited(_body: Node2D) -> void:
	var ui := get_tree().get_first_node_in_group("ui")
	if ui:
		ui.hide_dialog()
	
	inside_area = false


# -----------------------------
# Choice Spawning
# -----------------------------
func _on_setup_finished() -> void:
	spawn_choices()
	
	enum_collector.set_expected_answers(correct_answers)

func spawn_choices() -> void:
	collector_pos = enum_collector.position

	var used_x: Array[float] = []
	var padding := 8

	for option in options:
		var choice: Node2D = choice_template.instantiate()
		var min_spacing := _get_choice_width(choice) + padding

		var spawn_x := _get_valid_x(used_x, min_spacing)

		used_x.append(spawn_x)
		choice.position = Vector2(spawn_x, collector_pos.y)
		choice.value = option

		choices.append(choice)
		add_child(choice)

func _get_choice_width(choice: Node2D) -> float:
	var zone = choice.get_node("InteractionZone")
	return zone.shape.size.x


func _get_valid_x(used_x: Array[float], min_spacing: float) -> float:
	var attempts := 0

	while attempts < 50:
		attempts += 1
		var x := collector_pos.x - randi_range(50, 225)

		var valid := true
		for used in used_x:
			if abs(x - used) < min_spacing:
				valid = false
				break

		if valid:
			return x

	# Fallback (never freeze)
	return collector_pos.x


func _on_enum_collector_submitted(correct: bool) -> void:
	if correct:
		global.announce_status("CORRECT")
		global.add_score()
	else:
		global.announce_status("WRONG")
		global.reduce_life()
	
	global.num_of_submit += 1
	global.is_finished_level()
