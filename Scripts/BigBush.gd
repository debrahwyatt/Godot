extends StaticBody2D

@onready var selection = $Selection

var Berry = preload("res://Scenes/Berry.tscn")

var map_coordinates

var berries = []
var value = 50.0
var timer_max = 10000

var berry_count

var berry_offset = 10.0

#func GenerateBerry(x,y):
#	var new_berry = Berry.instantiate()
#	new_berry.position = Vector2(x,y)
#	add_child(new_berry)
#	berries.append(new_berry)


#func _ready():
#	berries = [$Berry1, $Berry2, $Berry3, $Berry4, $Berry5, $Berry6]
#	berry_count = randf_range(-1, 3)
#	berry_offset = berry_offset / 2.0
#
#	for i in berry_count: 
#		berries[-1].queue_free()
#		berries.pop_back()
#	for x in berries: x.translate(Vector2(randf_range(-berry_offset, berry_offset), randf_range(-berry_offset, berry_offset)))


func Selected(boolean): 
	selection.visible = boolean


func Targeted(_boolean): pass
#	selection.visible = boolean


func interact():
	for b in berries:
		if b.visible == true:
			b.picked()
			return 
