extends Area2D

@onready var label = $Label

var map_coordinates
var structure = ""


func SetStructure(_s): 
	return
#	structure = s

func _on_area_entered(area):
	if area.get_parent().is_in_group("Players"): area.get_parent().ChangeTerrain("grass")
	
func _process(_delta):
	label.text = structure


func GenerateGrass(map, nodes, rows, cols):
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"]["name"] == "": 
				map[x][y]["terrain"] = nodes["terrain"]["grass"]
