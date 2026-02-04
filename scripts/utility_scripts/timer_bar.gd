extends MarginContainer

@export var timer_limit: int = 180

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel

var time_left: float

func _ready():
	time_left = global.get_max_time()
	if time_left <= 0:
		time_left = 180 # fallback

	timer.wait_time = 0.05
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

	_update_timer_label()

func _on_timer_timeout():
	time_left -= timer.wait_time
	time_left = max(time_left, 0)

	_update_timer_label()

	if time_left <= 0:
		timer.stop()
		_on_timer_finished()

func _update_timer_label():
	if time_left > 5:
		timer_label.modulate = Color.WHITE

		var minutes := int(time_left) / 60
		var seconds := int(time_left) % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]
	else:
		timer_label.modulate = Color.RED
		timer_label.text = "%.2f" % time_left

func _on_timer_finished():
	global.trigger_game_over()
	timer_label.text = "0.00"
