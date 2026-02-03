extends Label


var score: int = 0

func _ready() -> void:
	self.text = "SCORE: " + str(score)

func _process(delta: float) -> void:
	if global.points <= 0:
		return
	
	score += 1
	global.points -= 1
	
	self.text = "SCORE: " + str(score)
