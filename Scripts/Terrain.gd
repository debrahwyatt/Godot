extends Node

var map_coordinates
var structure = ""


func InitializeGrass(map, nodes, rows, cols):
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"]["name"] == "": 
				map[x][y]["terrain"] = nodes["terrain"]["grass"]


func InitializeDeepWater(map, nodes, rows, cols):
	var water_types = ["water", "deep_water"]
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"]["name"] == "water":
				if y - 2 >= 0 and (map[x][y - 1]["terrain"]["name"] not in water_types || map[x][y - 2]["terrain"]["name"] not in water_types): continue
				if x - 2 >= 0 and (map[x - 1][y]["terrain"]["name"] not in water_types || map[x - 2][y]["terrain"]["name"] not in water_types): continue
				if x + 2 < rows and (map[x + 1][y]["terrain"]["name"] not in water_types || map[x + 2][y]["terrain"]["name"] not in water_types): continue
				if y + 2 < cols and (map[x][y + 1]["terrain"]["name"] not in water_types || map[x][y + 2]["terrain"]["name"] not in water_types): continue

				# Check corners and check if deep water isn't touching off the map
				if (x + 1 < rows) && (y + 1 < cols) && (x - 1 >= 0) && (y - 1 >= 0):
					if (map[x - 1][y - 1]["terrain"]["name"] not in water_types): continue
					if (map[x - 1][y + 1]["terrain"]["name"] not in water_types): continue
					if (map[x + 1][y + 1]["terrain"]["name"] not in water_types): continue
					if (map[x + 1][y - 1]["terrain"]["name"] not in water_types): continue

				map[x][y]["terrain"] = nodes["terrain"]["deep_water"]


func InitializeWater(map, nodes, rows, cols):
	var sum = 0
	var potential_list = []
	var water_features = []
	var total_water = nodes["terrain"]["water"]["percent"] * cols * rows
	
#	Determine water starting positions
	while sum < total_water:
		var pool_size = randi() % int(total_water/nodes["terrain"]["water"]["saturation"])
		water_features.append(pool_size)
		sum += pool_size
	print("Water features count: ", water_features.size(), ", Sum: ", sum)
	
#	Select the first drop for the pool
	var k = 1
	for feature_size in water_features:
		print("Building feature: ", k, ". Feature size: ", feature_size); k += 1
		
		#Find a random map coordinate that isn't already water
		var x = randi() % rows; var y = randi() % cols
#		while map[x][y]["node"]["name"] != nodes["water"]["terrain"]: x = randi() % rows; y = randi() % cols
		while map[x][y]["terrain"]["name"] != nodes["terrain"]["water"]["terrain"]: x = randi() % rows; y = randi() % cols
		
		map[x][y]["terrain"] = nodes["terrain"]["water"]
		
#		Create the first list of potential expansion squares
		if x + 1 < rows: 
			if map[x + 1][y]["terrain"]["name"] != "water":
				potential_list.append(map[x + 1][y])
		if x - 1 >= 0: 
			if map[x - 1][y]["terrain"]["name"] != "water":
				potential_list.append(map[x - 1][y])
		if y + 1 < cols: 
			if map[x][y + 1]["terrain"]["name"] != "water":
				potential_list.append(map[x][y + 1])
		if y - 1 >= 0: 
			if map[x][y - 1]["terrain"]["name"] != "water":
				potential_list.append(map[x][y - 1])
		
#		Select the next available squares and loop it
		for i in range(feature_size):
			var index = randi() % potential_list.size()
			var random_potential = potential_list[index]

			#Erase any entry that is already water from our potential
			while true:
#				select a random size for the pool up to a maximum
				if random_potential["terrain"]["name"] == "water": 
					potential_list.erase(index)
					index = randi() % potential_list.size()
					random_potential = potential_list[index]
					continue
				break


#			if random_potential["terrain"]["name"] == "water":
#				potential_list.erase(index)
#				i -= 1
#				continue
			
			if random_potential["x"] + 1 < rows: 
				if map[random_potential["x"] + 1][random_potential["y"]]["terrain"]["name"] != "water":
					potential_list.append(map[random_potential["x"] + 1][random_potential["y"]])
			if random_potential["x"] - 1 >= 0: 
				if map[random_potential["x"] - 1][random_potential["y"]]["terrain"]["name"] != "water":
					potential_list.append(map[random_potential["x"] - 1][random_potential["y"]])
			if random_potential["y"] + 1 < cols: 
				if map[random_potential["x"]][random_potential["y"] + 1]["terrain"]["name"] != "water":
					potential_list.append(map[random_potential["x"]][random_potential["y"] + 1])
			if random_potential["y"] - 1 >= 0: 
				if map[random_potential["x"]][random_potential["y"] - 1]["terrain"]["name"] != "water":
					potential_list.append(map[random_potential["x"]][random_potential["y"] - 1])
	
			random_potential["terrain"] = nodes["terrain"]["water"]
		potential_list = []
	print("Water added...")
	var l = 0
	for x in map:
		for y in x:
			if y["terrain"]["name"] == "water":
				l += 1
	print(l)
	print("sum/l = ", l * 1.0 / sum)


