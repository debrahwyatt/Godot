extends CharacterBody2D

enum Gender { FEMALE, MALE }

#Load Nodes
@onready var Name = $Name
@onready var player_selection = $Selection

var eat_sound = preload("res://Player/chew.wav")
var Berries = preload("res://Dingleberry Bush/berry_bush.gd")
var Player = preload("res://Player/player.tscn")

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

var is_moving = false 
var selected = false


func _init(): pass


func _ready():
	Name.text = p_name
	ui_list.append(Name)


func _input(_event):
	if Input.is_action_pressed("Moving") and selected:
		target_position = get_global_mouse_position() 
		is_moving = true
		
func move(_delta):
	if is_moving:
		move_character_to_target(_delta)
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
	
	
func showUI():
	if Input.is_action_pressed("left_ctrl_pressed"): makeNodesVisible(true)
	if Input.is_action_just_released("left_ctrl_pressed"): makeNodesVisible(false)


func _physics_process(_delta):
	if health_cur <= 0: return
	player_selection.visible = selected # TODO: Don't need to check every moment
	showUI()
	move(_delta)


func eat(value):
	$AudioStream2D.play()
	if value == null: value = 0 # TODO: value coming up as null?
	hunger_cur += value
	if hunger_cur > 100: hunger_cur = hunger_max 
	

func interact(player2):
	if gender == Gender.FEMALE && player2.gender == Gender.MALE:
		var new_player = Player.instantiate()
		new_player.position = Vector2(self.get_position().x , self.get_position().y)
		call_deferred("add_child", new_player)
		
	
func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	var children = area.get_parent().get_children()
	var berry_list = []
	var player2 
		
	var berry = RegEx.new()
	berry.compile('Berry.*')
	
	var player = RegEx.new()
	player.compile('Player.*')
	

	if player.search(parent.name): player2 = parent
	
	for x in children: 
		if berry.search(x.name): berry_list.append(x)
			
	if berry_list: eat(berries.pick(berry_list))
	if player2: interact(player2)
