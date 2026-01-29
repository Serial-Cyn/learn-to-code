extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite

signal selected(id: int)

enum ID { NOT_SET, A, B, C, D }

var is_in_interaction_zone: bool = false
var is_interacted: bool = false
var id: int = ID.NOT_SET

func _process(delta: float) -> void:
	# Checkc if ID is NOT_SET to avoid unnecessary steps
	if id == ID.NOT_SET:
		return
		
	if not is_in_interaction_zone:
		return
		
	if Input.is_action_just_pressed("interact"):
		is_interacted = true
				
		# To process the answer
		selected.emit(id)


func _on_body_entered(body: Node2D) -> void:
	if id != ID.NOT_SET:
		is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	if id != ID.NOT_SET:
		is_in_interaction_zone = false
