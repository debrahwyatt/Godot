extends CanvasLayer

func _init():
	visible = false

func _input(_event):
	if Input.is_action_pressed("Esc"):
		visible = !visible


func _on_quit_button_down():
	print("Quit Pressed")
	get_tree().quit()
#	get_parent().get_parent().visible = true


func _on_resume_button_down():
	visible = false
	print("Resume Pressed")


func _on_save_button_down():
	pass # Replace with function body.


func _on_help_button_down():
	pass # Replace with function body.


func _on_title_screen_button_down():
	var TitleScreen = get_parent().get_parent().get_parent().get_children()[0]
	TitleScreen.visible = true
	get_parent().get_parent().queue_free()
