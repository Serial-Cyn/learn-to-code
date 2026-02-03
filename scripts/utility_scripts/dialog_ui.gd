extends CanvasLayer

@onready var panel := $DialogBar
@onready var question_label := $DialogBar/MarginContainer/VBoxContainer/Label

@export var heart_sprite: PackedScene

var typing_id := 0

func _ready():
	hide_dialog()

func show_dialog(text: String) -> void:
	typing_id += 1
	var current_id = typing_id

	question_label.text = ""
	panel.visible = true

	for i in text.length():
		if current_id != typing_id:
			return # stop old typing

		question_label.text += text[i]
		await get_tree().create_timer(0.03).timeout

func hide_dialog() -> void:
	typing_id += 1 # invalidate current typing
	panel.visible = false
