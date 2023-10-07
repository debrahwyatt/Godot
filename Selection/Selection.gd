extends Node2D

var selected = false
var selecting = false

var action_timer = 0.5  
var timer_elapsed = 0.0
var action_pressed = false

var selected_list = []
var new_selected_list = []

var selection_end = Vector2()
var selection_start = Vector2()
var selection_color = Color(0, 0, 1, 0.2)  # Blue with 20% opacity

var target
##	if distance < 10m && targeted == true

func _target():
	for x in get_tree().get_nodes_in_group("Targetable"):
		if Rect2(x.global_position - x.shape.extents * 1.5, x.shape.extents * 3).abs().has_point(get_global_mouse_position()):
			for y in selected_list: y.cur_target = x.get_parent()
			return


func _input(event):
	
	if Input.is_action_just_pressed("Targeting") and selected_list != []: _target()
	
	if Input.is_action_just_pressed("Selecting"):
		selection_start = event.position
		selection_end = event.position
	
	if Input.is_action_pressed("Selecting"): selecting = true

	if Input.is_action_just_released("Selecting") && selection_end != Vector2(0, 0):
		selecting = false
		_selected()
		
#	if Input.is_action_just_released("Selecting") && selection_end == Vector2(0, 0):
#		selecting = false
#		$RayCast2D.position = get_local_mouse_position()
#		$RayCast2D.target_position = get_local_mouse_position() + Vector2(1, 1)
#		var object = $RayCast2D.get_collider()
#		print($RayCast2D.target_position)
#		print(get_local_mouse_position())
#
#		if object && object.has_method("select_unit"):
#			print(object.position)
#			object.select_unit()
#			selected_list.append(object)
		
	queue_redraw()
	if selecting: selection_end = event.position - selection_start


func _draw() -> void: 
	if selecting: 
		draw_rect(Rect2(selection_start, selection_end), selection_color)


func _selected():
	var players = get_tree().get_nodes_in_group("Players")
	for child in selected_list: child.selected = false
	new_selected_list = []
	for child in players:
		if Rect2(selection_start, selection_end).abs().has_point(child.position):
			new_selected_list.append(child)
			child.selected = true
		
	selected_list = new_selected_list
	selected = false
