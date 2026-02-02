extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var choice_name: Label = $ChoiceName

signal selected(id: int)

var is_in_interaction_zone: bool = false
var is_interacted: bool = false
var id: int = -1
var choice_value = "I'm not done yet!"

func _process(delta: float) -> void:
	choice_name.text = choice_value
	
	# Checkc if ID is NOT_SET to avoid unnecessary steps
	if id < 0:
		return
	
	if not is_in_interaction_zone:
		choice_name.visible = false
		return
	
	# Player is within interaction zone
	choice_name.visible = true
		
	if Input.is_action_just_pressed("interact"):
		is_interacted = true
				
		# To process the answer
		selected.emit(id)


func _on_body_entered(body: Node2D) -> void:
	if not id < 0:
		is_in_interaction_zone = true
		sprite.play("hover")


func _on_body_exited(body: Node2D) -> void:
	if not id < 0:
		is_in_interaction_zone = false
		sprite.play("idle")
