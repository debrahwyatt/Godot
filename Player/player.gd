extends CharacterBody2D

const SPEED = 200  # Adjust the player's speed as needed
var velocity1 = Vector2()  # Player's current velocity

enum Gender { FEMALE, MALE }

#Load Nodes
@onready var Name = $Name
@onready var Selection = $Selection

var eat_sound = preload("res://Player/chew.wav")

var Trees = preload("res://Tree/Tree.gd")
var trees = Trees.new()

var Berries = preload("res://Bush/bush.gd")
var berries = Berries.new()

var ui_list = []

var rng = RandomNumberGenerator.new()
func rnd():	return rng.randf_range(-10.0, 10.0)

var p_name = "Richard"
var gender = randi() % 2
var speed_max = 100.0 + rnd()
var speed_cur = speed_max

var health_max = 100.0 + rnd()
var health_cur = health_max

var hunger_max = 100.0 + rnd()
var hunger_cur = hunger_max

var sleep_max = 100.0 + rnd()
var sleep_cur = sleep_max

var happiness_max = 100 + rnd()
var happiness_cur = happiness_max

var target_position = Vector2(0, 0)
var map_coordinates
var is_moving = false 
var is_moving2 = false 
var selected = false
var cur_target = Node2D
var input_vector = Vector2()


func _init(): pass

func _ready():
	Name.text = p_name
	ui_list.append(Name)

func Selected(boolean):
	selected = boolean
	Selection.visible = boolean
	

func _input(_event):
	if Input.is_action_pressed("Moving") and selected:
		target_position = get_global_mouse_position() 
		is_moving = true
	
	if (Input.is_action_just_pressed("Keyboard Movement") or Input.is_action_pressed("Keyboard Movement")) and selected: 
		is_moving2 = true
		# Read input from arrow keys
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	if (Input.is_action_just_released("Keyboard Movement")) and selected:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		is_moving2 = false


func move_character_keyboard(_delta):
		# Calculate the player's velocity based on input and speed
		position = position + input_vector.normalized() * speed_cur * _delta
		move_and_slide()


func move(_delta):
	if is_moving:
		move_character_to_target(_delta)
		move_and_slide()
		$IdleAnimation.stop()
		$WalkAnimation.play("Walk")
		if hunger_cur > 0: hunger_cur -= 0.01
		else: health_cur -= 0.01
	elif is_moving2:
		move_character_keyboard(_delta)
		move_and_slide()
		$IdleAnimation.stop()
		$WalkAnimation.play("Walk")
		if hunger_cur > 0: hunger_cur -= 0.01
		else: health_cur -= 0.01
	else: 
		hunger_cur -= 0.001
		$WalkAnimation.stop()
		$IdleAnimation.play("Idle")


func move_character_to_target(delta):
	var direction = (target_position - position).normalized()
	position += direction * speed_cur * delta
	if position.distance_to(target_position) < 10.0: is_moving = false


func makeNodesVisible(visibility):
	for child in ui_list: child.visible = visibility


func eat(value):
	$AudioStream2D.play()
	if value == null: value = 0 # TODO: value coming up as null?
	hunger_cur += value
	if hunger_cur > 100: hunger_cur = hunger_max 
	

func interact(_player2):
	pass
#	if gender == Gender.FEMALE && player2.gender == Gender.MALE:
#		var Player = preload("res://Player/player.tscn")
#		var new_player = Player.instantiate()
#		new_player.position = Vector2(self.get_position().x , self.get_position().y)
#		call_deferred("add_sibling", new_player)


func _on_area_2d_area_entered(_area):
	pass
#	for x in area.get_parent().get_children():
#		if x == cur_target:
#			x.get_parent().interact()


#	var player2 
#	if player.search(parent.name): player2 = parent
#	if berry_list: eat(berries.pick(berry_list))
#	if player2: interact(player2)


func _physics_process(_delta):
	if health_cur <= 0: return
#	showUI()
	move(_delta)

