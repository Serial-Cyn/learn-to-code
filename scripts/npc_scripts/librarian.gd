extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var name_label: Label = $NameLabel

var is_in_interaction_zone: bool = false
var player: Node2D = null

# SIGNAL FUNCTIONS
func _on_body_entered(body: Node2D) -> void:
	is_in_interaction_zone = true

func _on_body_exited(body: Node2D) -> void:
	is_in_interaction_zone = false

# MAIN FUNCTION
func _ready() -> void:
	player = global.player

func _process(delta: float) -> void:
	
	# NPC is always facing player to add immersiveness
	if player:
		var player_pos_x = player.global_position.x
		var librarian_pos_x = self.global_position.x
		
		if player_pos_x > librarian_pos_x:
			sprite.flip_h = false
		elif player_pos_x < librarian_pos_x:
			sprite.flip_h = true
	
	# To avoid visual clutter, names will only show when player is near
	if is_in_interaction_zone:
		name_label.visible = true
	else:
		name_label.visible = false
