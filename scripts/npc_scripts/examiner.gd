extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var name_label: Label = $NameLabel

# REGISTRATION WINDOW
@onready var admin: Window = $Admin
@onready var name_field: LineEdit = $Admin/CameraWindow/NameField
@onready var password_field: LineEdit = $Admin/CameraWindow/PasswordField
@onready var show_password_btn: Button = $Admin/CameraWindow/ShowPasswordBtn

var is_in_interaction_zone: bool = false
var player: Node2D = null

# SIGNAL FUNCTIONS
func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false

# MAIN FUNCTION
func _ready() -> void:
	admin.hide()
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
		
		if Input.is_action_just_pressed("interact"):
			global.can_move = false # Stop the player from twitching
			admin.show() # Show admin form
	else:
		name_label.visible = false


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
	else:
		global.announce_status("Incorrect username or password!") # Displays a message in the status bar
	
	admin.hide()
	global.can_move = true


func _on_close_btn_button_down() -> void:
	global.can_move = true # Don't let the player stuck!
	admin.hide() # Hide admin form


func _on_show_password_btn_button_down() -> void:
	password_field.secret = !password_field.secret
	
	if password_field.secret:
		show_password_btn.text = "-"
	else:
		show_password_btn.text = "O"
