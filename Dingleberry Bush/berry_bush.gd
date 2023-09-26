extends StaticBody2D


@onready var timers = [0, 0, 0]
@onready var berries = [$Berry1, $Berry2, $Berry3]


var value = 50.0
var timer = Timer.new() 


func pick(children):
	if children[0].visible == false && children[1].visible == false && children[2].visible == false: return
	for x in children: if x.visible == true: x.visible = false;	return value
	

func grow(b): for i in range(0, 3): if b[i].visible == false: b[i].visible = true; return


func _ready():
	timer.connect("timeout", timeout)
	timer.wait_time = 3
	add_child(timer)
	timer.start()

func timeout(): grow(berries)


func _process(_delta): pass
