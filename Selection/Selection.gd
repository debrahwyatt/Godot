extends Node2D

var selectable_list = []
var new_selected_list = []
var old_selected_list = []

var selected = false
var selecting = false

var selection_end = Vector2()
var selection_start = Vector2()
var selection_color = Color(0, 0, 1, 0.2)  # Blue with 20% opacity


func _ready():
	for child in get_parent().get_children():
		var regex = RegEx.new()
		regex.compile('Player.*')
		if regex.search(child.name): selectable_list.append(child)
		

func _input(event):
	
	if Input.is_action_just_pressed("Selecting"):
		selecting = true
		selection_end = event.position
		selection_start = event.position
	
	if Input.is_action_pressed("Selecting"): 
		selection_end = event.position - selection_start

	if Input.is_action_just_released("Selecting"):
		selecting = false
		_selected()
	
	queue_redraw()


func _draw() -> void: if selecting: draw_rect(Rect2(selection_start, selection_end), selection_color)


func _selected():
	var players = get_tree().get_nodes_in_group("Players")
	for child in old_selected_list: child.selected = false
	new_selected_list = []
	for child in players:
		if Rect2(selection_start, selection_end).abs().has_point(child.position):
			new_selected_list.append(child)
			child.selected = true
		
	old_selected_list = new_selected_list
	selected = false

func _process(_delta):
	pass
