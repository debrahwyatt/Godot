extends Area2D

@onready var label = $Label

var map_coordinates
var structure = ""

func SetStructure(_s): 
	return
#	structure = _s

func _on_area_entered(area):
	if area.get_parent().is_in_group("Players"): area.get_parent().ChangeTerrain("water")

func _process(_delta):
	label.text = structure


func GenerateWater(map, nodes, rows, cols):
	var sum = 0
	var potential_list = []
	var water_features = []
	var total_water = nodes["terrain"]["water"]["percent"] * cols * rows
	
#	Determine water starting positions
	while sum < total_water:
		var pool_size = randi() % int(total_water/nodes["terrain"]["water"]["saturation"])
		water_features.append(pool_size)
		sum += pool_size
	
#	Select the first drop for the pool
	for feature_size in water_features:
		#Find a random map coordinate that isn't already water
		var x = randi() % rows; var y = randi() % cols
#		while map[x][y]["node"]["name"] != nodes["water"]["terrain"]: x = randi() % rows; y = randi() % cols
		while map[x][y]["terrain"]["name"] != nodes["terrain"]["water"]["terrain"]: x = randi() % rows; y = randi() % cols
		map[x][y]["terrain"] = nodes["terrain"]["water"]
		
#		Create the first list of potential expansion squares
		if x + 1 < rows: potential_list.append(map[x + 1][y])
		if x - 1 >= 0: potential_list.append(map[x - 1][y])
		if y + 1 < cols: potential_list.append(map[x][y + 1])
		if y - 1 >= 0: potential_list.append(map[x][y - 1])
		
#		Select the next available squares and loop it
		for i in feature_size:
			var index = randi() % potential_list.size()
			var random_potential = potential_list[index]
			
			#Erase any entry that is already water from our potential
			while true:
#				select a random size for the pool up to a maximum
				index = randi() % potential_list.size()
				random_potential = potential_list[index]
				if random_potential["terrain"]["name"] == nodes["terrain"]["water"]["name"]: 
					potential_list.erase(index)
					continue
				break
			
			random_potential["terrain"] = nodes["terrain"]["water"]
			if random_potential["x"] + 1 < rows: potential_list.append(map[random_potential["x"] + 1][random_potential["y"]])
			if random_potential["x"] - 1 >= 0: potential_list.append(map[random_potential["x"] - 1][random_potential["y"]])
			if random_potential["y"] + 1 < cols: potential_list.append(map[random_potential["x"]][random_potential["y"] + 1])
			if random_potential["y"] - 1 >= 0: potential_list.append(map[random_potential["x"]][random_potential["y"] - 1])
	return map
