extends Node2D

@onready var timer = $Timer
@onready var sprite = $Berry

var value = 50 + randi() % 10


func picked():
	timer.start(value)
	set_visible(false)
	return value


func _on_timer_timeout():
	timer.stop()
	set_visible(true)
