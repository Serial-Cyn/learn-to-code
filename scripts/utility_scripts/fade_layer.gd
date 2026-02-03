extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

func fade_out():
	anim.play("fade_out")

func fade_in():
	anim.play("fade_in")
