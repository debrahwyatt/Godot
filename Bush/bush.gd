extends StaticBody2D

@onready var berries = [$Berry1, $Berry2, $Berry3]

var map_coordinates

var value = 50.0
var timer_max = 10000


func interact():
	for b in berries:
		if b.visible == true:
			b.picked()
			return 
