extends Node2D

@onready var player: AnimatedSprite2D = $CanvasLayer/player

var avatar: String = "miyuki"

func _on_button_button_down() -> void:
	global.change_scene("res://scenes/levels/start_floor.tscn")


func _on_change_avatar_btn_button_down() -> void:
	if avatar == "miyuki":
		avatar = "yukihiko"
	else:
		avatar = "miyuki"

	player.play(avatar)
	global.set_avatar(avatar)
