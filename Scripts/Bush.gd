extends StaticBody2D

@onready var selection = $Selection

var Berry = preload("res://Scenes/Berry.tscn")

var map_coordinates

var s_name = "Bush"
var berries = []
var berry_offset = 4.0


func _ready():
	berries = [$Berry1, $Berry2, $Berry3]
	berry_offset = berry_offset / 2.0
	for x in berries: x.translate(Vector2(randf_range(-berry_offset, berry_offset), randf_range(-berry_offset, berry_offset)))


func GenerateBerry(x,y):
	var new_berry = Berry.instantiate()
	new_berry.position = Vector2(x,y)
	add_child(new_berry)
	berries.append(new_berry)


func Selected(boolean): 
	selection.visible = boolean


func Targeted(boolean):
	selection.visible = boolean


func PickBerry():
	for b in berries:
		if b.visible == true:
			b.picked()
			return b.value
