extends Window

@onready var mc_spin: SpinBox = $Parent/Section/Split/Controllers/MCSpin
@onready var tf_spin: SpinBox = $Parent/Section/Split/Controllers/TFSpin
@onready var identify_spin: SpinBox = $Parent/Section/Split/Controllers/IdentifySpin
@onready var enum_spin: SpinBox = $Parent/Section/Split/Controllers/EnumSpin
@onready var time_spin: SpinBox = $Parent/Section/Split/Controllers/TimeSpin

const SETTINGS_PATH := "user://settings.save"

var mc_num: int = 5
var tf_num: int = 5
var identify_num: int = 5
var enum_num: int = 5
var time_num: int = 180

var loading := false

func _ready() -> void:
	hide()
	load_settings()
	
	mc_spin.value = mc_num
	tf_spin.value = tf_num
	identify_spin.value = identify_num
	enum_spin.value = enum_num
	time_spin.value = time_num

func _on_close_requested() -> void:
	hide()
	load_settings()

func _on_mc_spin_value_changed(value: float) -> void:
	if loading:
		return
	mc_num = int(value)

func _on_tf_spin_value_changed(value: float) -> void:
	if loading:
		return
	tf_num = int(value)

func _on_identify_spin_value_changed(value: float) -> void:
	if loading:
		return
	identify_num = int(value)

func _on_enum_spin_value_changed(value: float) -> void:
	if loading:
		return
	enum_num = int(value)

func _on_time_spin_value_changed(value: float) -> void:
	if loading:
		return
	time_num = int(value)


func _on_go_back_btn_button_down() -> void:
	hide()

func _on_save_btn_button_down() -> void:
	var floor_count: Array = [mc_num, tf_num, identify_num, enum_num]

	if not save_settings():
		global.announce_status("FAILED TO SAVE!")
		return

	var success = global.update_game_settings(floor_count, time_num)
	if not success:
		global.announce_status("FAILED TO APPLY!")

	global.announce_status("NEW FLOOR COUNT SAVED!")

func save_settings() -> bool:
	var data := {
		"mc": mc_num,
		"tf": tf_num,
		"identify": identify_num,
		"enum": enum_num,
		"time": time_num
	}

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		return false

	file.store_string(JSON.stringify(data))
	file.close()
	return true

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return

	var result = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(result) != TYPE_DICTIONARY:
		return

	loading = true

	mc_num = result.get("mc", 5)
	tf_num = result.get("tf", 5)
	identify_num = result.get("identify", 5)
	enum_num = result.get("enum", 5)
	time_num = result.get("time", 180)

	mc_spin.value = mc_num
	tf_spin.value = tf_num
	identify_spin.value = identify_num
	enum_spin.value = enum_num
	time_spin.value = time_num

	loading = false

	global.update_game_settings(
		[mc_num, tf_num, identify_num, enum_num],
		time_num
	)
