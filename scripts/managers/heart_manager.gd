extends HBoxContainer

@onready var hearts: Dictionary = {
	1: $Heart1,
	2: $Heart2,
	3: $Heart3
}

var life: int = 0

func _ready() -> void:
	life = global.life

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if life == global.life:
		return
	
	life -= 1
	
	if life <= 0:
		global.trigger_game_over()
	
	var ctr: int = 0
	for heart in hearts.values():
		if ctr == life:
			heart.play("broken")
		
		ctr += 1
