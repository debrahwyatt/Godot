extends CharacterBody2D

const SPEED = 200  # Adjust the player's speed as needed
var velocity1 = Vector2()  # Player's current velocity

enum Gender { FEMALE, MALE }

#Load Nodes
@onready var Name = $Name
@onready var Selection = $Selection

var eat_sound = preload("res://Sounds/Chew.wav")

var Trees = preload("res://Scripts/Tree.gd")
var trees = Trees.new()

var Berries = preload("res://Scripts/Bush.gd")
var berries = Berries.new()

var ui_list = []

var rng = RandomNumberGenerator.new()
func rnd():	return rng.randf_range(-10.0, 10.0)

var gender
var p_name

var map_coordinates

var age = 18 + randi() % 5 + randi() % 1 
var age_drain = 0.001

var speed_max = 100.0 + rnd()
var speed_cur = speed_max

var health_max = 100.0 + rnd()
var health_cur = health_max
var health_drain = 0.1

var hunger_max = 100.0 + rnd()
var hunger_cur = hunger_max
var hunger_drain = 0.005

var energy_loss = false
var energy_max = 100 + rnd()
var energy_cur = energy_max
var energy_drain = 0.05

var happy_max = 100 + rnd()
var happy_cur = happy_max
var happy_drain = 0.01

var luck = 101

var is_moving = false
var selected = false
var to_target = false

var cur_target = Node2D
var input_vector = Vector2()
var target_position = Vector2(0, 0)

var terrain = "grass"
var water_modifier = 0.66
var deep_water_modifier = 0.33

var direction = (target_position - position).normalized()
	
var male_name_list = ["Dick", "Roger", "Peter", "Rodney", "Richard", "William", "Willy"]
var female_name_list = ["Darcy", "Regina", "Petunia", "Rose", "Tabitha", "Wendy", "Milly", "Winnifred"]

func SetStructure(_s): pass

func initiate(g):
	gender = g
	if gender == 0: p_name = female_name_list[randi() % female_name_list.size()]
	else: p_name = male_name_list[randi() % male_name_list.size()]


func _on_area_2d_area_entered(area_object):
	if cur_target == area_object: print("HERE")


func _physics_process(_delta):
	age += age_drain
	if health_cur <= 0:
		queue_free()
		return

	Move(_delta)
	
#	Drowning I think?
	if energy_loss == true:
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
	$AudioStream2D.play()
	if value == null: value = 0 # TODO: value coming up as null?
	hunger_cur += value
	if hunger_cur > 100: hunger_cur = hunger_max


func _input(_event):
	if Input.is_action_pressed("Moving") and selected:
		target_position = get_global_mouse_position()
		direction = (target_position - position).normalized()
		is_moving = true
		to_target = true
		return

	if Input.is_action_just_pressed("Keyboard Movement"):
		is_moving = false
		to_target = false
		target_position = Vector2(-1, -1)
	
	if selected && to_target == false:
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
		else: health_cur -= health_drain
	else:
		if energy_cur < energy_max: energy_cur += energy_drain * 3
		if hunger_cur > 0: hunger_cur -= hunger_drain
		if happy_cur > 0: happy_cur -= happy_drain
		$WalkAnimation.stop()
		$IdleAnimation.play("Idle")


func MoveToTarget(delta):
	position += direction * speed_cur * delta
	if position.distance_to(target_position) < 10.0: 
		is_moving = false
		to_target = false
		target_position = Vector2(-1, -1)


func interact(player2):
	pass
	if gender == Gender.FEMALE && player2.gender == Gender.MALE:
		var Player = preload("res://Scenes/MalePlayer.tscn")
		var new_player = Player.instantiate()
		new_player.position = Vector2(self.get_position().x , self.get_position().y)
		call_deferred("add_sibling", new_player)
