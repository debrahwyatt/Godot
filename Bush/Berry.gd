extends Node2D

@onready var timer = $Timer
@onready var sprite = $Sprite


func picked():
	timer.start(10)
	set_visible(false)


func _on_timer_timeout():
	timer.stop()
	set_visible(true)
