extends Control

@onready var Button0 = $Button0

var water_colour = Color(1, 0.5, 1)  

func _draw():
	draw_rect(Rect2(100, 100, 200, 200), water_colour)


func _on_Button_pressed():
	# Your code here
	print("Button pressed!")

func _input(_event):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the UI overlay initially
#	self.hide()
	draw_rect(Rect2(300, 300, 900, 900), water_colour)

# Show the UI overlay
func show_ui():
	self.show()

# Hide the UI overlay
func hide_ui():
	self.hide()
