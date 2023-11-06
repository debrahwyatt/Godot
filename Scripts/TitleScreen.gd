extends CanvasLayer
@onready var tsc = $"TitleScreen Camera"

func _ready():
	$Music.play()
	

func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	visible = false
	add_sibling(preload("res://Scenes/Map.tscn").instantiate())
