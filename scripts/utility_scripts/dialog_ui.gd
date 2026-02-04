extends CanvasLayer

@onready var panel := $DialogBar
@onready var question_label := $DialogBar/MarginContainer/VBoxContainer/Label

@export var heart_sprite: PackedScene

var pressed_again: bool = false
var typing_id := 0

func _ready():
	hide_dialog()

# Shows dialog with typing effect, stable layout
func show_dialog(text: String) -> void:
	typing_id += 1
	var current_id = typing_id

	# Pre-fill the text but hide all characters
	question_label.text = text
	question_label.visible_characters = 0  # This is the key
	panel.visible = true

	for i in range(text.length()):
		# Skips the animation if player wants to
		if Input.is_action_just_pressed("interact"):
			if pressed_again:
				question_label.visible_characters = text.length()
				return
			
			pressed_again = true

		if current_id != typing_id:
			return # stop old typing

		question_label.visible_characters = i + 1
		await get_tree().create_timer(0.03).timeout

# Instantly hide dialog and cancel typing
func hide_dialog() -> void:
	pressed_again = false
	typing_id += 1 # invalidate current typing
	panel.visible = false
