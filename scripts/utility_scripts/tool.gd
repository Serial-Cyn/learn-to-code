extends Area2D

@export var book_name: String = "(>_<)"
@export var sprite: SpriteFrames

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var label: Label = $Name
@onready var window: Window = $Window

var in_interaction_zone: bool = false

func _ready() -> void:
	label.visible = false
	
	if sprite != null:
		animated_sprite.sprite_frames = sprite

func _process(delta: float) -> void:
	if not in_interaction_zone:
		return
	
	if Input.is_action_just_pressed("interact"):
		window.show()

func _on_body_entered(body: Node2D) -> void:
	label.text = book_name
	label.visible = true
	in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	label.visible = false
	in_interaction_zone = false
