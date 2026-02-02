extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var name_label: Label = $NameLabel

# REGISTRATION WINDOW
@onready var admin: Window = $Admin
@onready var name_field: LineEdit = $Admin/CameraWindow/NameField
@onready var password_field: LineEdit = $Admin/CameraWindow/PasswordField
@onready var show_password_btn: Button = $Admin/CameraWindow/ShowPasswordBtn

# QUESTIONNAIRE FORMS
@onready var multiple_choice_window: Window = $MultipleChoiceWindow
@onready var true_or_false_window: Window = $TrueOrFalseWindow
@onready var identification_window: Window = $IdentificationWindow
@onready var enumeration_window: Window = $EnumerationWindow
@onready var menu: Window = $Menu

# MULTIPLE CHOICE
@onready var mc_question_field: LineEdit = $MultipleChoiceWindow/CameraWindow/QuestionField
@onready var mc_choices: ItemList = $MultipleChoiceWindow/CameraWindow/Choices
@onready var a_field: LineEdit = $MultipleChoiceWindow/CameraWindow/ChoiceFields/AField
@onready var b_field: LineEdit = $MultipleChoiceWindow/CameraWindow/ChoiceFields/BField
@onready var c_field: LineEdit = $MultipleChoiceWindow/CameraWindow/ChoiceFields/CField
@onready var d_field: LineEdit = $MultipleChoiceWindow/CameraWindow/ChoiceFields/DField

# TRUE OR FALSE
@onready var tf_question_field: LineEdit = $TrueOrFalseWindow/CameraWindow/QuestionField
@onready var tf_choices: ItemList = $TrueOrFalseWindow/CameraWindow/Choices

# IDENTIFICATION
@onready var i_question_field: LineEdit = $IdentificationWindow/CameraWindow/QuestionField
@onready var i_answer_field: LineEdit = $IdentificationWindow/CameraWindow/AnswerField

# ENUMERATION
@onready var question_field: LineEdit = $EnumerationWindow/CameraWindow/QuestionField
@onready var answer_field: LineEdit = $EnumerationWindow/CameraWindow/AnswerField
@onready var items_field: TextEdit = $EnumerationWindow/CameraWindow/ItemsField


var is_in_interaction_zone: bool = false
var player: Node2D = null

# MAIN FUNCTION
func _ready() -> void:
	admin.hide()
	multiple_choice_window.hide()
	true_or_false_window.hide()
	identification_window.hide()
	enumeration_window.hide()
	
	player = global.player

func _process(delta: float) -> void:
	
	# NPC is always facing player to add immersiveness
	if player:
		var player_pos_x = player.global_position.x
		var examiner_pos_x = self.global_position.x
		
		if player_pos_x > examiner_pos_x:
			sprite.flip_h = false
		elif player_pos_x < examiner_pos_x:
			sprite.flip_h = true
	
	# To avoid visual clutter, names will only show when player is near
	if is_in_interaction_zone:
		name_label.visible = true
		
		if Input.is_action_just_pressed("interact") and global.can_move:
			global.can_move = false # Stop the player from twitching
			admin.show() # Show admin form
	else:
		name_label.visible = false

# SIGNAL FUNCTIONS
func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false

func _on_admin_close_requested() -> void:
	global.can_move = true # Don't let the player stuck!
	admin.hide() # Hide registration form


func _on_login_btn_button_down() -> void:
	var username: String = name_field.text
	var password: String = global.hash_password(password_field.text) # Gets the password and hashes it immediately
	var type = "admin"
	
	var is_success: bool = global.find_player(username, password, type) # Looks for an admin account
	
	if is_success:
		global.announce_status("Hello, Admin!") # Displays a message in the status bar
		admin.hide()
		menu.show()
	else:
		global.announce_status("Incorrect username or password!") # Displays a message in the status bar


func _on_close_btn_button_down() -> void:
	global.can_move = true # Don't let the player stuck!
	admin.hide() # Hide admin form


func _on_show_password_btn_button_down() -> void:
	password_field.secret = !password_field.secret
	
	if password_field.secret:
		show_password_btn.text = "-"
	else:
		show_password_btn.text = "O"


func _on_multiple_choice_window_close_requested() -> void:
	multiple_choice_window.hide()
	menu.show()

func _on_true_or_false_window_close_requested() -> void:
	true_or_false_window.hide()
	menu.show()

func _on_identification_window_close_requested() -> void:
	identification_window.hide()
	menu.show()

func _on_enumeration_window_close_requested() -> void:
	enumeration_window.hide()
	menu.show()


func _on_mc_back_btn_button_down() -> void:
	multiple_choice_window.hide()
	menu.show()

func _on_tf_back_btn_button_down() -> void:
	true_or_false_window.hide()
	menu.show()

func _on_i_back_btn_button_down() -> void:
	identification_window.hide()
	menu.show()

func _on_e_back_btn_button_down() -> void:
	enumeration_window.hide()
	menu.show()


func _on_mc_submit_btn_button_down() -> void:
	var question: String = mc_question_field.text.strip_edges()
	
	# Gather choices (A–D)
	var choice_fields := [a_field, b_field, c_field, d_field]
	var choices_array := []
	
	for field in choice_fields:
		var text: String = field.text.strip_edges()
		if text != "":
			choices_array.append(text)
	
	# VALIDATION
	if question == "":
		global.announce_status("Question cannot be empty.")
		return
	
	if choices_array.size() < 2:
		global.announce_status("At least 2 choices are required.")
		return
	
	if mc_choices.get_selected_items().is_empty():
		global.announce_status("Please select the correct answer.")
		return
	
	var answer_index: int = mc_choices.get_selected_items()[0]
	if answer_index < 0 or answer_index >= choices_array.size():
		global.announce_status("Selected answer is invalid.")
		return
	
	# Convert choices array to JSON
	var choices_json: String = JSON.stringify(choices_array)
	
	# SUBMIT TO DATABASE
	var success: bool = global.add_mc_question(question, choices_json, answer_index)
	
	if success:
		global.announce_status("Multiple choice question saved successfully!")
		_clear_mc_form()
	else:
		global.announce_status("Failed to save question.")

func _on_tf_submit_btn_button_down() -> void:
	var question: String = tf_question_field.text.strip_edges()
	
	# VALIDATION
	if question == "":
		global.announce_status("Question cannot be empty.")
		return
	
	if tf_choices.get_selected_items().is_empty():
		global.announce_status("Please select the correct answer.")
		return
	
	var answer_index: int = tf_choices.get_selected_items()[0]
	
	if answer_index != 0 and answer_index != 1:
		global.announce_status("Invalid True/False selection.")
		return
	
	# SUBMIT TO DATABASE
	var success: bool = global.add_tf_question(question, answer_index)
	
	if success:
		global.announce_status("True/False question saved successfully!")
		_clear_tf_form()
	else:
		global.announce_status("Failed to save True/False question.")

func _on_i_submit_btn_button_down() -> void:
	var question: String = i_question_field.text.strip_edges()
	var answer: String = i_answer_field.text.strip_edges().to_lower()
	
	# VALIDATION
	if question == "":
		global.announce_status("Question cannot be empty.")
		return
	
	if answer == "":
		global.announce_status("Answer cannot be empty.")
		return
	
	# SUBMIT TO DATABASE
	var success: bool = global.add_identify_question(question, answer)
	
	if success:
		global.announce_status("Identification question saved successfully!")
		_clear_identify_form()
	else:
		global.announce_status("Failed to save identification question.")

func _on_e_submit_btn_button_down() -> void:
	var question: String = question_field.text.strip_edges()
	var raw_text: String = items_field.text.strip_edges().to_lower()
	
	# VALIDATION
	if question == "":
		global.announce_status("Question cannot be empty.")
		return
	
	if raw_text == "":
		global.announce_status("Enumeration items cannot be empty.")
		return
	
	# PARSE ITEMS (one per line)
	var answer_items: Array[String] = []
	
	for line in raw_text.split("\n"):
		var item := line.strip_edges()
		if item != "":
			answer_items.append(item)
	
	if answer_items.is_empty():
		global.announce_status("At least one valid item is required.")
		return
	
	# SUBMIT TO DATABASE
	var success: bool = global.add_enum_question(
		question,
		JSON.stringify(answer_items)
	)
	
	if success:
		global.announce_status("Enumeration question saved successfully!")
		_clear_enum_form()
	else:
		global.announce_status("Failed to save enumeration question.")


# UTILITY FUNCTIONS
func _clear_mc_form() -> void:
	mc_question_field.clear()
	a_field.clear()
	b_field.clear()
	c_field.clear()
	d_field.clear()
	mc_choices.deselect_all()

func _clear_tf_form() -> void:
	tf_question_field.clear()
	tf_choices.deselect_all()

func _clear_identify_form() -> void:
	i_question_field.clear()
	i_answer_field.clear()

func _clear_enum_form() -> void:
	question_field.clear()
	items_field.clear()


func _on_mc_btn_button_down() -> void:
	menu.hide()
	multiple_choice_window.show()

func _on_tf_btn_button_down() -> void:
	menu.hide()
	true_or_false_window.show()

func _on_enum_btn_button_down() -> void:
	menu.hide()
	enumeration_window.show()

func _on_identify_btn_button_down() -> void:
	menu.hide()
	identification_window.show()

func _on_menu_close_requested() -> void:
	global.can_move = true
	menu.hide()
