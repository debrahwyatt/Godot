extends Control

@onready var Player = $CanvasLayer/BottomBar/Player
@onready var FemalePlayer = $CanvasLayer/BottomBar/FemalePlayer

@onready var Name = $CanvasLayer/BottomBar/Name
@onready var Health = $CanvasLayer/BottomBar/Health
@onready var Energy = $CanvasLayer/BottomBar/Energy
@onready var Hunger = $CanvasLayer/BottomBar/Hunger
@onready var Happy = $CanvasLayer/BottomBar/Happy
@onready var Speed = $CanvasLayer/BottomBar/Speed
@onready var Luck = $CanvasLayer/BottomBar/Luck
@onready var Age = $CanvasLayer/BottomBar/Age
@onready var Sex = $CanvasLayer/BottomBar/Sex

@onready var esc = $EscMenu

var selected_list = []
var top_player

var players = preload("res://Scenes/Player.tscn").instantiate()
#var Player = preload("res://Scripts/Player.gd").new()

var sex = ["Female", "Male"]
enum Stats {BAR, VALUE}

func _physics_process(_delta):
	if top_player && is_instance_valid(top_player):
		
		var x = 248

		Health.get_child(Stats.VALUE).text = str(int(top_player.health_cur)) + " / " + str(int(top_player.health_max))
		Health.get_child(Stats.BAR).size.x =int((top_player.health_cur / top_player.health_max) * x)
		
		Energy.get_child(Stats.VALUE).text = str(int(top_player.energy_cur)) + " / " + str(int(top_player.energy_max))
		Energy.get_child(Stats.BAR).size.x = int((top_player.energy_cur / top_player.energy_max) * x)
		
		Hunger.get_child(Stats.VALUE).text = str(int(top_player.hunger_cur)) + " / " + str(int(top_player.hunger_max))
		Hunger.get_child(Stats.BAR).size.x = int((top_player.hunger_cur / top_player.hunger_max) * x)
		
		Happy.get_child(Stats.VALUE).text = str(int(top_player.happy_cur)) + " / " + str(int(top_player.happy_max))
		Happy.get_child(Stats.BAR).size.x = int((top_player.happy_cur / top_player.happy_max) * x)
		
		Speed.get_child(Stats.VALUE).text = str(int(top_player.speed_cur)) 
		Luck.get_child(Stats.VALUE).text = str(int(top_player.luck))
		Age.get_child(Stats.VALUE).text = str(int(top_player.age))
	
	else: MakeStatsVisible(false)


func StatVisible(obj, boolean):
	obj.visible = boolean
	for x in obj.get_children(): x.visible = boolean
	
	
func MakeStatsVisible(boolean):
	if top_player && is_instance_valid(top_player):
		if top_player.gender == 0: FemalePlayer.visible = boolean
		else: Player.visible = boolean
	
	Name.visible = boolean
	StatVisible(Health, boolean)
	StatVisible(Energy, boolean)
	StatVisible(Hunger, boolean)
	StatVisible(Happy, boolean)
	StatVisible(Sex, boolean)
	StatVisible(Luck, boolean)
	StatVisible(Speed, boolean)
	StatVisible(Age, boolean)
	
	
# Brings in the selected_list
func UpdateUI(sl):
	selected_list = sl
	Player.visible = false
	FemalePlayer.visible = false
	
	if selected_list != []: top_player = selected_list[0]
	if selected_list == []: MakeStatsVisible(false)
	else:
		MakeStatsVisible(true)
		
		Name.text = selected_list[0].p_name
		Health.get_child(Stats.VALUE).text = str(int(selected_list[0].health_cur)) + " / " + str(int(selected_list[0].health_max))		
		Energy.get_child(Stats.VALUE).text = str(int(selected_list[0].energy_cur)) + " / " + str(int(selected_list[0].energy_max))
		Hunger.get_child(Stats.VALUE).text = str(int(selected_list[0].hunger_cur)) + " / " + str(int(selected_list[0].hunger_max))
		Happy.get_child(Stats.VALUE).text = str(int(selected_list[0].hunger_cur)) + " / " + str(int(selected_list[0].happy_max))
		Sex.get_child(Stats.VALUE).text = sex[selected_list[0].gender]
		
		Speed.get_child(Stats.VALUE).text = str(int(selected_list[0].speed_cur))
		Luck.get_child(Stats.VALUE).text = str(int(selected_list[0].luck))
		Happy.get_child(Stats.VALUE).text = str(int(selected_list[0].happy_cur))
		Age.get_child(Stats.VALUE).text = str(int(selected_list[0].age))


func _input(_event):
	if Input.is_action_pressed("Esc"):
		esc.visible = !esc.visible


func _on_quit_button_down():
	print("Quit Pressed")
	get_parent().queue_free()
#	get_parent().get_parent().visible = true


func _on_resume_button_down():
	esc.visible = false
	print("Resume Pressed")
