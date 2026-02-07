extends Area2D

@export var state: int = 0 # 0 = start leve, 1 = library

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var name_label: Label = $NameLabel

var is_in_interaction_zone: bool = false
var player: Node2D = null

# SIGNAL FUNCTIONS
func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true
	name_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false
	name_label.visible = false

# MAIN FUNCTION
func _ready() -> void:
	name_label.visible = false
	player = global.player

func _process(delta: float) -> void:
	if not is_in_interaction_zone:
		return
	
	# NPC is always facing player to add immersiveness
	if player:
		var player_pos_x = player.global_position.x
		var librarian_pos_x = self.global_position.x
		
		if player_pos_x > librarian_pos_x:
			sprite.flip_h = false
		elif player_pos_x < librarian_pos_x:
			sprite.flip_h = true
	
	if Input.is_action_just_pressed("interact"):
		if state == 0:
			global.change_scene("res://scenes/levels/library_floor.tscn")
		else:
			global.change_scene("res://scenes/levels/start_floor.tscn")
		
