extends Area2D

@onready var interaction_zone: CollisionShape2D = $InteractionZone

signal picked(answer: String)

var is_in_interaction_zone: bool = false
var value: String

func _process(delta: float) -> void:
	if value.is_empty():
		return
		
	if is_in_interaction_zone and Input.is_action_just_pressed("interact"):
		picked.emit(value)
			
		toggle_choice(false)


func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false
	
func toggle_choice(state: bool):
	interaction_zone.disabled = true
	self.visible = false
	
