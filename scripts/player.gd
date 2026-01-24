extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var status_bar: VBoxContainer = $CanvasLayer/StatusBar

const PIXEL_OPERATOR_8 = preload("uid://c0bgh10idc3tl")

const SPEED: float = 130.0
const JUMP_VELOCITY: float = -300.0

func _enter_tree() -> void:
	global.player = self

func _physics_process(delta: float) -> void:
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")

	handle_gravity(delta)		# Applies gravity and jump movement
	handle_animation(direction) # Applies animation of different actions
	
	# For instances that requires the player to stay still
	if global.can_move:
		handle_movement(direction)	# Applies movement
	
	# Checks if there is any status labels to avoid unnecessary processing
	if status_bar.get_children():
		fade_out_statuses() # Fade out status labels

	move_and_slide()

func handle_gravity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_animation(direction: int):
	# Flip the sprite
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	else:
		sprite.play("jump")
		
func handle_movement(direction: int):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


# UTILITY FUNCTIONS
func add_status_label(text: String):
	var new_announcement = Label.new()
	
	new_announcement.text = text
	new_announcement.add_theme_font_override("font", PIXEL_OPERATOR_8)
	new_announcement.add_theme_font_size_override("font_size", 16)
	new_announcement.horizontal_alignment = 2
	status_bar.add_child(new_announcement)

func fade_out_statuses():
	for child in status_bar.get_children():
		if child is Label:
			var label_tween: Tween = create_tween()
			
			label_tween.tween_property(child, "modulate", Color(1, 1, 1, 0), 5.0)
			label_tween.tween_callback(child.queue_free) # Destroys the status after disappearing
