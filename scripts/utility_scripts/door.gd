extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var choice_name: Label = $ChoiceName
@onready var interaction_zone: CollisionShape2D = $InteractionZone

signal selected(state: bool)

var choice_value: String = "Not yet!"
var in_interaction_zone: bool = false
var state: int = -1
var is_disabled: bool = false

var is_pressing := false

func _ready() -> void:
	sprite.play("close")
	choice_name.visible = false

func _process(delta: float) -> void:
	choice_name.text = choice_value
	
	# Avoids unnecessary steps if state is null. NULL = NOT CONFIGURED
	if state < 0:
		return
	
	if is_disabled or is_pressing:
		return
	
	if not in_interaction_zone:
		return
	
	# Check the value of state to determine what sprite to use
	if Input.is_action_just_pressed("interact"):
		press()
		selected.emit(state)

func _on_body_entered(body: Node2D) -> void:
	if state >= 0:
		choice_name.visible = true
		in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	if state >= 0:
		choice_name.visible = false
		in_interaction_zone = false

func disable_door() -> void:
	is_disabled = true

func press() -> void:
	is_pressing = true
	sprite.play("open")

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "open":
		sprite.play("close")
		is_pressing = false
