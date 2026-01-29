extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite

signal interacted(state: bool)

enum STATE { NULL, FALSE, TRUE }

var is_in_interaction_zone: bool = false
var is_interacted: bool = false
var state: int = STATE.NULL

func _process(delta: float) -> void:
	# Avoids unnecessary steps if state is null. NULL = NOT CONFIGURED
	if state == STATE.NULL:
		return
		# Check the value of state to determine what sprite to use
	if not is_interacted:
		if state != STATE.FALSE:
			sprite.play("close_t")
		else:
			sprite.play("close_f")
			
		if Input.is_action_just_pressed("interact"):
			is_interacted = true
				
	else:
		if state != STATE.FALSE:
			sprite.play("open_t")
			interacted.emit(true)
		else:
			sprite.play("open_f")
			interacted.emit(false)

func _on_body_entered(body: Node2D) -> void:
	if state != STATE.NULL:
		is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	if state != STATE.NULL:
		is_in_interaction_zone = false
