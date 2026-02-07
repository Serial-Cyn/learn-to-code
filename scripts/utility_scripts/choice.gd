extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var choice_name: Label = $ChoiceName

signal selected(id: int)

var is_in_interaction_zone: bool = false
var is_disabled: bool = false
var is_pressing: bool = false
var id: int = -1
var choice_value = "(>_<)"

func _ready() -> void:
	sprite.play("idle")
	choice_name.visible = false

func _process(delta: float) -> void:
	choice_name.text = choice_value
	
	# Checkc if ID is NOT_SET to avoid unnecessary steps
	if id < 0:
		return
	
	if is_disabled:
		return
	
	if not is_in_interaction_zone:
		return
		
	if Input.is_action_just_pressed("interact"):		
		# To process the answer
		press()
		selected.emit(id)
		disable_door()

func press() -> void:
	is_pressing = true
	sprite.play("pressed")

func _on_body_entered(body: Node2D) -> void:
	if not id < 0:
		choice_name.visible = true
		is_in_interaction_zone = true


func _on_body_exited(body: Node2D) -> void:
	if not id < 0:
		choice_name.visible = false
		is_in_interaction_zone = false

func disable_door() -> void:
	is_disabled = true

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "pressed":
		sprite.play("idle")
		is_pressing = false
