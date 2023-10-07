extends Node2D

var selected = false
var selecting = false

var action_timer = 0.5  
var timer_elapsed = 0.0
var action_pressed = false

var selected_list = []

var selection_end = Vector2()
var selection_start = Vector2()
var selection_color = Color(0, 0, 1, 0.2)  # Blue with 20% opacity

var target
##	if distance < 10m && targeted == true

func _target():
	for x in get_tree().get_nodes_in_group("Targetable"):
		if Rect2(x.global_position - x.shape.extents * 1.5, x.shape.extents * 3).abs().has_point(get_global_mouse_position()):
			for y in selected_list: 
				target = x.get_parent().get_parent()
				target.Targeted()
				y.cur_target = x.get_parent()
			return


func _input(event):
	queue_redraw()
	if Input.is_action_just_pressed("Targeting") and selected_list != []: _target()
	
	if Input.is_action_just_pressed("Selecting"):
		selection_start = event.position
		selection_end = event.position
	
	if Input.is_action_pressed("Selecting"): 
		selecting = true
		selection_end = event.position - selection_start


	if Input.is_action_just_released("Selecting") && selection_end != Vector2(0, 0):
		selecting = false
		SelectGroup("Players")
		
	if Input.is_action_just_released("Selecting") && selection_end == Vector2(0, 0):
		for x in get_tree().get_nodes_in_group("Selectable"):
			if Rect2(x.global_position - x.shape.extents * 1.5, x.shape.extents * 3).abs().has_point(get_global_mouse_position()):
				var child = x.get_parent().get_parent()
				if child.name == "level": child = x.get_parent()
				for item in selected_list: item.Selected(false)
				child.Selected(true)
				selected_list = [child]
				return
				
		if selected_list != []:
			for child in selected_list: child.Selected(false)
			selected_list = []


func _draw() -> void: 
	if selecting: 
		draw_rect(Rect2(selection_start, selection_end), selection_color)


func SelectGroup(group):
	
	var new_selected_list = []
	for child in selected_list: child.Selected(false)
	
	var players = get_tree().get_nodes_in_group(group)
	for child in players:
		if Rect2(selection_start, selection_end).abs().has_point(child.position):
			new_selected_list.append(child)
			child.Selected(true)
	
	selected_list = new_selected_list
	selected = false
