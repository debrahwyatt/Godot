extends CanvasLayer
@onready var tsc = $"TitleScreen Camera"

func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	visible = false
	var th = preload("res://Scenes/Map.tscn").instantiate()
	th.Music = $Music.playing
	add_sibling(th)


func _on_settings_pressed():
	$Control.visible = false
	$Control2.visible = true


func _on_back_button_pressed():
	$Control.visible = true
	$Control2.visible = false


func _on_check_button_toggled(button_pressed):
	$Music.playing = button_pressed
