extends Area2D

# NPC DATA
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var name_label: Label = $NameLabel

# REGISTRATION WINDOW
@onready var registration: Window = $Registration
@onready var name_field: LineEdit = $Registration/CameraWindow/NameField
@onready var password_field: LineEdit = $Registration/CameraWindow/PasswordField
@onready var show_password_btn: Button = $Registration/CameraWindow/ShowPasswordBtn

var is_in_interaction_zone: bool = false
var player: Node2D = null

# SIGNAL FUNCTIONS
func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false

# MAIN FUNCTION
func _ready() -> void:
	registration.hide()		# Hide popup
	player = global.player	# Get Player data

func _process(delta: float) -> void:
	
	# NPC is always facing player to add immersiveness
	if player:
		var player_pos_x = player.global_position.x
		var gate_keeper_pos_x = self.global_position.x
		
		if player_pos_x > gate_keeper_pos_x:
			sprite.flip_h = false
		elif player_pos_x < gate_keeper_pos_x:
			sprite.flip_h = true
	
	# To avoid visual clutter, names will only show when player is near
	if is_in_interaction_zone:
		name_label.visible = true
		
		if Input.is_action_just_pressed("interact"):
			global.can_move = false # Stop the player from twitching
			registration.show() # Show registration form
	else:
		name_label.visible = false

# SIGNAL FUNCTIONS
func _on_registration_close_requested() -> void:
	global.can_move = true # Don't let the player stuck!
	registration.hide() # Hide registration form

func _on_register_btn_button_down() -> void:
	var username: String = name_field.text
	var password: String = global.hash_password(password_field.text) # Gets the password and hashes it immediately

	var is_success: bool = global.add_player(username, password) # Stores it in database
	
	if is_success:
		global.announce_status("You are now registered!") # Displays a message in the status bar
		registration.hide()
	else:
		global.announce_status("Username already taken!") # Displays a message in the status bar
		registration.hide()
	
	global.can_move = true

func _on_close_btn_button_down() -> void:
	global.can_move = true # Don't let the player stuck!
	registration.hide() # Hide registration form


func _on_show_password_btn_button_down() -> void:
	password_field.secret = !password_field.secret
	
	if password_field.secret:
		show_password_btn.text = "-"
	else:
		show_password_btn.text = "O"
