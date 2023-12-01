extends CharacterBody2D

enum Gender { FEMALE, MALE }

@onready var Name = $Name
@onready var Selection = $Selection

func rnd(): return RandomNumberGenerator.new().randf_range(-10.0, 10.0)

var gender
var p_name

var map_coordinates

var age = 28 + rnd()
var age_drain = 0.001
var age_max = 100 + rnd()

var speed_max = 150.0 + rnd() * 1.5
var speed_cur = speed_max

var health_max = 100.0 + rnd()
var health_cur = health_max
var health_drain = 0.1

var hunger_max = 100.0 + rnd()
var hunger_cur = hunger_max
var hunger_drain = 0.005

var energy_max = 100 + rnd()
var energy_cur = energy_max
var energy_drain = 0.05

var happy_max = 100 + rnd()
var happy_cur = happy_max
var happy_drain = 0.01

var luck = 101

var selected = false
var is_moving = false
var to_target = false
var energy_loss = false

var terrain = "grass"
var water_modifier = 0.66
var deep_water_modifier = 0.33

var cur_target = Node2D
var target_position = Vector2(0, 0)

var direction = (target_position - position).normalized()
var structure = {
	"name": "",
	"object": null
}

var player = {
	"name": "player",
	"terrain": "grass",
	"node": preload("res://Scenes/Player.tscn"),
	"code": "P",
}


var male_name_list = [
	"Dick", 
	"Roger", 
	"Peter", 
	"Rodney", 
	"Richard", 
	"William", 
	"Willy", 
	"Steve",
	"Wang",
	"Frank",
	"Francis",
	"Bobby",
	"Oscar",
	"Angus"
	]
	
var female_name_list = [
	"Darcy", 
	"Regina", 
	"Petunia", 
	"Rose", 
	"Tabitha", 
	"Wendy", 
	"Milly", 
	"Winnifred",
	"Frankie",
	"Bobbie",
	"Mildred",
	"Hagatha",
	"Agnus"
	]
	
var last_name_list = male_name_list + female_name_list


func Death(): 
	if gender == 0: 
		print("Female Death")
		$FemaleDeath.play()
	else:
		print("Male Death") 
		$MaleDeath.play()
	queue_free()


func initiate(g):
	gender = g
	if gender == 0: p_name = female_name_list[randi() % female_name_list.size()] + " " + last_name_list[randi() % last_name_list.size()]
	else: p_name = male_name_list[randi() % male_name_list.size()] + " " + last_name_list[randi() % last_name_list.size()]


func _physics_process(_delta):
	age += age_drain
	if $Sprite/OldBody.visible == false and age >= 60.0: 
		$Sprite/Body.visible = false
		$Sprite/OldBody.visible = true
	
	if age >= age_max: Death()
	if health_cur <= 0: Death()
	if energy_loss == true: Drowning()
	
	Move(_delta)


func Drowning():
	energy_cur -= energy_drain
	if energy_cur < 0:
		energy_cur = 0
		health_cur -= health_drain


func ChangeTerrain(new_terr):
	terrain = new_terr
	if terrain == "grass": speed_cur = speed_max
	if terrain == "water":
		speed_cur = speed_max * water_modifier
		energy_loss = false
		
	if terrain == "deep_water":
		speed_cur = speed_max * deep_water_modifier
		energy_loss = true


func Selected(boolean):
	selected = boolean
	Selection.visible = boolean


func Eat(value):
	if value == null || value == 0: return
	$AudioStream2D.play()
	
	hunger_cur += value
	if hunger_cur > hunger_max: hunger_cur = hunger_max
	
	happy_cur += value / 10.0
	if happy_cur > happy_max: happy_cur = happy_max


func _input(_event):
	if Input.is_action_pressed("Keyboard Action") and selected:
		if structure["name"] == "Bush": Eat(structure["object"].PickBerry())
	
	if Input.is_action_pressed("Moving") and selected:
		target_position = get_global_mouse_position()
		direction = (target_position - position).normalized()
		is_moving = true
		to_target = true
		return

	if Input.is_action_just_pressed("Keyboard Movement") && selected:
		is_moving = false
		to_target = false
		target_position = Vector2(-1, -1)
	
	if to_target == false && selected:
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		if direction != Vector2(0, 0): is_moving = true
		else: is_moving = false


# This should be a state machine
func Move(_delta):
	if is_moving:
		MoveToTarget(_delta)
		move_and_slide()
		
		$IdleAnimation.stop()
		$WalkAnimation.play("Walk")
		if energy_cur > 0: energy_cur -= energy_drain
		if hunger_cur > 0: hunger_cur -= hunger_drain * 2
		else: health_cur -= hunger_drain * 2
	else:
		$WalkAnimation.stop()
		$IdleAnimation.play("Idle")
		if energy_cur < energy_max: energy_cur += energy_drain * 3
		if happy_cur > 0: happy_cur -= happy_drain
		if hunger_cur > 0: hunger_cur -= hunger_drain
		else: health_cur -= hunger_drain


func MoveToTarget(delta):
	position += direction * speed_cur * delta
	if position.distance_to(target_position) < 10.0: 
		is_moving = false
		to_target = false
		target_position = Vector2(-1, -1)


func interact(player2):
	if gender == Gender.FEMALE && player2.gender == Gender.MALE:
		var Player = preload("res://Scenes/Player.tscn")
		var new_player = Player.instantiate()
		new_player.position = Vector2(self.get_position().x , self.get_position().y)
		call_deferred("add_sibling", new_player)


func _on_area_2d_area_entered(area_object):
	print(area_object)
	if area_object.get_parent().s_name == "Bush":
		structure["name"] = "Bush"
		structure["object"] = area_object.get_parent()
		
	if cur_target == area_object: 
		#Stop the player
		to_target = false
		is_moving = false
		
		if area_object.get_parent().s_name == "Player":
			interact(area_object)
			
		if area_object.get_parent().s_name == "Tree":
			area_object.get_parent().Chopping(true)
			print("HERE3")
			pass
			
		if area_object.get_parent().s_name == "Bush":
			Eat(area_object.get_parent().PickBerry())
	

func Targeted(boolean):
	Selection.visible = boolean


func _on_area_2d_area_exited(area_object):
#	print(area_object)
	if area_object.get_parent() == structure["object"]:
		structure["name"] = ""
		structure["object"] = null


func _on_area_2d_2_area_entered(_area):
	print("HERE")
	pass # Replace with function body.
