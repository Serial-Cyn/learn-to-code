extends Area2D

@export var book_name: String = "(>_<)"
@export var description: String = "I don't know what to say..."
@export var sprite: SpriteFrames

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var label: Label = $Name

var in_interaction_zone: bool = false

var dialog_ui: CanvasLayer

func _ready() -> void:
	label.visible = false
	
	if get_tree().get_first_node_in_group("ui"):
		dialog_ui = get_tree().get_first_node_in_group("ui")
	
	if sprite != null:
		animated_sprite.sprite_frames = sprite

func _process(delta: float) -> void:
	if not in_interaction_zone:
		return
	
	if Input.is_action_just_pressed("interact"):
		dialog_ui.show_dialog(description)

func _on_body_entered(body: Node2D) -> void:
	label.text = book_name
	label.visible = true
	in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	dialog_ui.hide_dialog()
	label.visible = false
	in_interaction_zone = false
