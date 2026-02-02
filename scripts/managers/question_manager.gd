extends Node
class_name QuestionManager

var question_queue: Array = []
var mc_questions: Array = []
var tf_questions: Array = []
var identify_questions: Array = []
var enum_questions: Array = []

func load_all_questions(database) -> void:
	_load_mc(database)
	_load_tf(database)
	_load_identify(database)
	_load_enum(database)

	# Combine & shuffle for endless mode
	question_queue = []
	question_queue.append_array(mc_questions)
	question_queue.append_array(tf_questions)
	question_queue.append_array(identify_questions)
	question_queue.append_array(enum_questions)

	question_queue.shuffle()

func _load_mc(database) -> void:
	var rows = database.select_rows("tbl_choices", "", ["*"])
	
	for row in rows:
		mc_questions.append({
			"type": "mc",
			"question": row["question"],
			"choices": JSON.parse_string(row["choices"]),
			"answer": int(row["answer"])
		})

func _load_tf(database) -> void:
	var rows = database.select_rows("tbl_bool", "", ["*"])
	
	for row in rows:
		tf_questions.append({
			"type": "tf",
			"question": row["question"],
			"answer": int(row["answer"]) # 0 = True, 1 = False
		})

func _load_identify(database) -> void:
	var rows = database.select_rows("tbl_identify", "", ["*"])
	
	for row in rows:
		identify_questions.append({
			"type": "identify",
			"question": row["question"],
			"answer": row["answer"]
		})

func _load_enum(database) -> void:
	var rows = database.select_rows("tbl_enum", "", ["*"])
	
	for row in rows:
		enum_questions.append({
			"type": "enum",
			"question": row["question"],
			"answer": JSON.parse_string(row["answer"])
		})

func get_question_by_type(type: String) -> Dictionary:
	match type:
		"mc":
			return mc_questions.pop_front()
		"tf":
			return tf_questions.pop_front()
		"identify":
			return identify_questions.pop_front()
		"enum":
			return enum_questions.pop_front()
		_:
			return {}
