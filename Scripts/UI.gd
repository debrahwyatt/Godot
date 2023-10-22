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


var selected_list = []
var top_player

var players = preload("res://Scenes/MalePlayer.tscn").instantiate()
#var Player = preload("res://Scripts/Player.gd").new()

var sex = ["Male", "Female"]


func _physics_process(_delta):
	if top_player:
		Health.get_child(1).text = str(int(top_player.health_cur)) + " / " + str(int(top_player.health_max))
		Energy.get_child(1).text = str(int(top_player.energy_cur)) + " / " + str(int(top_player.energy_max))
		Hunger.get_child(1).text = str(int(top_player.hunger_cur)) + " / " + str(int(top_player.hunger_max))
		Happy.get_child(1).text = str(int(top_player.happy_cur)) + " / " + str(int(top_player.happy_max))
		Speed.get_child(1).text = str(int(top_player.speed_cur)) 
		Luck.get_child(1).text = str(int(top_player.luck))
		Age.get_child(1).text = str(int(top_player.age))
		

func StatVisible(obj, boolean):
	obj.visible = boolean
	for x in obj.get_children(): x.visible = boolean
	
	
func MakeStatsVisible(boolean):
	if top_player:
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
		Health.get_child(1).text = str(int(selected_list[0].health_cur)) + " / " + str(int(selected_list[0].health_max))
		Energy.get_child(1).text = str(int(selected_list[0].energy_cur)) + " / " + str(int(selected_list[0].energy_max))
		Hunger.get_child(1).text = str(int(selected_list[0].hunger_cur)) + " / " + str(int(selected_list[0].hunger_max))
		Happy.get_child(1).text = str(int(selected_list[0].hunger_cur)) + " / " + str(int(selected_list[0].happy_max))
		Sex.get_child(1).text = sex[selected_list[0].gender]
		
		Speed.get_child(1).text = str(int(selected_list[0].speed_cur))
		Luck.get_child(1).text = str(int(selected_list[0].luck))
		Happy.get_child(1).text = str(int(selected_list[0].happy_cur))
		Age.get_child(1).text = str(int(selected_list[0].age))
