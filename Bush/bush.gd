extends StaticBody2D

@onready var berries = [$Berry1, $Berry2, $Berry3]
@onready var selection = $Interaction
var map_coordinates

var value = 50.0
var timer_max = 10000

func Selected(boolean):
	selection.visible = boolean

func Targeted():
	print("targeted bush")

func interact():
	for b in berries:
		if b.visible == true:
			b.picked()
			return 
