extends StaticBody2D

@onready var Selection = $Selection

var berry_bush = preload("res://Scenes/Bush.tscn")

var map_coordinates
var s_name = "Tree"
var targeted = false
var chopping = false
var chopping_progress = 200

var player_list = []


func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("Players"):
		player_list.append(parent)
		if parent.cur_target == self: chopping = true


func _on_area_2d_area_exited(area):
	var parent = area.get_parent()
	if player_list:
		player_list.erase(parent)
		chopping = false


func _process(_delta): 
	if chopping == true: chopping_progress -= 1
	if chopping_progress == 0:
		chopping = false
		var TreeInstance = berry_bush.instantiate()
		TreeInstance.position = Vector2(self.position[0], self.position[1])
		TreeInstance.map_coordinates = [map_coordinates[0], map_coordinates[1]]
		add_sibling(TreeInstance)
		queue_free()


func _input(_event): pass
#	if Input.is_action_just_pressed("Targeting") &&  \
#	Rect2(Selectable_Space.global_position - Selectable_Space.shape.extents * 1.5, Selectable_Space.shape.extents * 3).abs().has_point(get_global_mouse_position()):
#		Selection.visible = true
#
#	if Input.is_action_just_pressed("ui_select") and player_list:
#		for x in player_list:
#			if x.selected: chopping = true


func Interact(_this_tree): 
	print("interact with tree", _this_tree)

func Targeted(boolean):
	Selection.visible = boolean

func Selected(boolean):
	Selection.visible = boolean
