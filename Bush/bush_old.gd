extends StaticBody2D

@onready var berries = [$Berry1, $Berry2, $Berry3]

var timer_max = 10000
var value = 50.0

var map_coordinates

func selected():
	pass
	

func interact():
	print("HEER")

func pick(children):
	if children[0].visible == false && children[1].visible == false && children[2].visible == false: 
		return
	for x in children: 
		if x.visible == true: 
			x.visible = false
			return value
	

func grow(): 
	for i in range(0, 3): 
		if berries[i].visible == false: 
			berries[i].visible = true; 
			return

func _ready():
	pass

#	timer.connect("timeout", timeout)
#	timer.wait_time = 3
#	add_child(timer)
#	timer.start()

#func timeout(): grow(berries)


func _process(_delta): 
	pass
#	for i in range(0, 3):
#		if timers[i] < timer_max && berries[i].visible == false: grow()
#		else: 
#			timers[i] += 1
#			print(timers[i])
