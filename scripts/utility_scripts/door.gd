extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var choice_name: Label = $ChoiceName

signal selected(state: bool)

var choice_value: String = "Not yet!"
var is_in_interaction_zone: bool = false
var is_interacted: bool = false
var state: int = -1

func _process(delta: float) -> void:
	choice_name.text = choice_value
	# Avoids unnecessary steps if state is null. NULL = NOT CONFIGURED
	if state < 0:
		return
	
	if not is_in_interaction_zone:
		choice_name.visible = false
		return
	
	choice_name.visible = true
	
	# Check the value of state to determine what sprite to use
	if not Input.is_action_just_pressed("interact"):
		if state == 1: # True
			sprite.play("close_t")
		else:
			sprite.play("close_f")
				
	else:
		if not is_interacted:
			if state == 1: # True
				sprite.play("open_t")
				selected.emit(true)
			else:
				sprite.play("open_f")
				selected.emit(false)
				
			is_interacted = true

func _on_body_entered(body: Node2D) -> void:
	if state >= 0:
		is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	if state >= 0:
		is_in_interaction_zone = false
