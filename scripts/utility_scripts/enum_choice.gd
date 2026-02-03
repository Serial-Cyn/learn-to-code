extends Area2D

@onready var interaction_zone: CollisionShape2D = $InteractionZone
@onready var choice_name: Label = $ChoiceName

var is_in_interaction_zone: bool = false
var value: String = ""

func _process(delta: float) -> void:
	choice_name.text = value
	
	if value.is_empty():
		return
	
	choice_name.visible = false
		
	if is_in_interaction_zone:
		choice_name.visible = true
		
		if Input.is_action_just_pressed("interact"):
			global.carry_item(self)


func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false
	
