extends Node2D

var UI
var target

var selected = false
var selecting = false

var action_timer = 0.5  
var timer_elapsed = 0.0
var action_pressed = false

var selected_list = []

var selection_end = Vector2()
var selection_start = Vector2()
var selection_color = Color(0, 0, 1, 0.2)  # Blue with 20% opacity


func _ready(): 
	UI = get_parent().get_child(1)

func _draw() -> void: 
	if selecting: 
		draw_rect(Rect2(selection_start, selection_end), selection_color)


func _input(event):
	queue_redraw()
	
#	Erase any objects that have been freed from the selected_list
	for x in selected_list: if !is_instance_valid(x): selected_list.erase(x)

#	Only listen to mouse clickes
	if event is InputEventKey: return
	
#	If the player has units selected and they right click, target that selected object
	if Input.is_action_just_pressed("Targeting") and selected_list != []: 
		Target()
		return
	
#	Start the selection process
	if Input.is_action_just_pressed("Selecting"):
		selection_start = get_global_mouse_position()
		selection_end = get_global_mouse_position()
		return
	
#	While holding down the select button
	if Input.is_action_pressed("Selecting"): 
		selecting = true
		selection_end = get_global_mouse_position() - selection_start
#		return
		
#	Let go of the select button, and select what's in the box
	if Input.is_action_just_released("Selecting"):
		if get_viewport().get_mouse_position() - selection_start == Vector2(0, 0): SingleClickSelect()
		else: SelectGroup("Players")
		selecting = false


func Target():
	for y in selected_list: y.cur_target = null
	if target: target.Targeted(false)
	for x in get_tree().get_nodes_in_group("Targetable"):
		if Rect2(x.global_position - x.shape.extents * 1.5, x.shape.extents * 3).abs().has_point(get_global_mouse_position()):
			for y in selected_list: 
				target = x.get_parent().get_parent()
				target.Targeted(true)
				y.cur_target = x.get_parent()


func SingleClickSelect():
	for x in get_tree().get_nodes_in_group("Selectable"):
		if Rect2(x.global_position - x.shape.extents * 1.5, x.shape.extents * 3).abs().has_point(get_global_mouse_position()):
			var child = x.get_parent().get_parent()
			
			if child.name == "level": child = x.get_parent()
			for item in selected_list: item.Selected(false)
			
			child.Selected(true)
			selected_list = [child]
			UI.UpdateUI(selected_list)


func SelectGroup(group):
	
	var new_selected_list = []
	for child in selected_list: child.Selected(false)
	
	var players = get_tree().get_nodes_in_group(group)
	for child in players:
		if Rect2(selection_start, selection_end).abs().has_point(child.position):
			new_selected_list.append(child)
			child.Selected(true)
	
	selected = false
	selected_list = new_selected_list
	
	UI.UpdateUI(selected_list)
