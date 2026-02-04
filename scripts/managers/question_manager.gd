extends Node
class_name QuestionManager

# -----------------------------
# SOURCE (never popped)
# -----------------------------
var mc_source: Array = []
var tf_source: Array = []
var identify_source: Array = []
var enum_source: Array = []

# -----------------------------
# RUNTIME (popped during play)
# -----------------------------
var mc_runtime: Array = []
var tf_runtime: Array = []
var identify_runtime: Array = []
var enum_runtime: Array = []

# -----------------------------
# PUBLIC API
# -----------------------------
func load_all_questions(database) -> void:
	_clear_all()

	_load_mc(database)
	_load_tf(database)
	_load_identify(database)
	_load_enum(database)

	_reset_runtime()

func reset_runtime() -> void:
	_reset_runtime()

# -----------------------------
# INTERNAL
# -----------------------------
func _clear_all() -> void:
	mc_source.clear()
	tf_source.clear()
	identify_source.clear()
	enum_source.clear()

	mc_runtime.clear()
	tf_runtime.clear()
	identify_runtime.clear()
	enum_runtime.clear()

func _reset_runtime() -> void:
	mc_runtime = mc_source.duplicate(true)
	tf_runtime = tf_source.duplicate(true)
	identify_runtime = identify_source.duplicate(true)
	enum_runtime = enum_source.duplicate(true)

	mc_runtime.shuffle()
	tf_runtime.shuffle()
	identify_runtime.shuffle()
	enum_runtime.shuffle()

# -----------------------------
# LOADERS (DB → SOURCE)
# -----------------------------
func _load_mc(database) -> void:
	var rows = database.select_rows("tbl_choices", "", ["*"])
	for row in rows:
		mc_source.append({
			"type": "mc",
			"question": row["question"],
			"choices": JSON.parse_string(row["choices"]),
			"answer": int(row["answer"])
		})

func _load_tf(database) -> void:
	var rows = database.select_rows("tbl_bool", "", ["*"])
	for row in rows:
		tf_source.append({
			"type": "tf",
			"question": row["question"],
			"answer": int(row["answer"])
		})

func _load_identify(database) -> void:
	var rows = database.select_rows("tbl_identify", "", ["*"])
	for row in rows:
		identify_source.append({
			"type": "identify",
			"question": row["question"],
			"answer": row["answer"]
		})

func _load_enum(database) -> void:
	var rows = database.select_rows("tbl_enum", "", ["*"])
	for row in rows:
		enum_source.append({
			"type": "enum",
			"question": row["question"],
			"answer": JSON.parse_string(row["answer"])
		})

# -----------------------------
# SAFE POP (USED BY LEVELS)
# -----------------------------
func get_question_by_type(type: String) -> Dictionary:
	match type:
		"mc":
			return _pop_runtime(mc_runtime)
		"tf":
			return _pop_runtime(tf_runtime)
		"identify":
			return _pop_runtime(identify_runtime)
		"enum":
			return _pop_runtime(enum_runtime)
		_:
			return {}

func _pop_runtime(arr: Array) -> Dictionary:
	if arr.is_empty():
		push_warning("Question runtime empty!")
		return {}
		
	return arr.pop_front()
