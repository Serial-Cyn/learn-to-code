extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var choice_name: Label = $ChoiceName
@onready var interaction_zone: CollisionShape2D = $InteractionZone

signal selected(state: bool)

var choice_value: String = "Not yet!"
var in_interaction_zone: bool = false
var state: int = -1
var is_disabled: bool = false

func _ready() -> void:
	choice_name.visible = false

func _process(delta: float) -> void:
	choice_name.text = choice_value
	
	# Avoids unnecessary steps if state is null. NULL = NOT CONFIGURED
	if state < 0:
		return
	
	if is_disabled:
		return
	
	if not in_interaction_zone:
		if state == 1: # True
			sprite.play("close_t")
		else:
			sprite.play("close_f")
			
		return
	
	# Check the value of state to determine what sprite to use
	if Input.is_action_just_pressed("interact"):
		if state == 1: # True
			sprite.play("open_t")
			selected.emit(true)
		else:
			sprite.play("open_f")
			selected.emit(false)

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
