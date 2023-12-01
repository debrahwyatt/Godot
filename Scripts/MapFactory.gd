extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_pressed():
	visible = false
	
	var th = preload("res://Scripts/Map.gd").new()

	th.map_multiplier = int($Control/HSlider.value)
#	th.Music = $Music.playing

	th.Initialize()
	th.Build()
	
	add_sibling(th)


func _on_h_slider_value_changed(value):
	$Control/LineEdit.text = str(value)
	pass # Replace with function body.
