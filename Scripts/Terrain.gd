extends Node

var map_coordinates
var structure = ""

var water_percent = 0.71
var grass_percent = 0.06

var water_colour = Color(0, 0.5, 1)  # Water blue
var grass_colour = Color(0, 0.5, 0.1)  # Dark grass green
var deep_water_colour = Color(0, 0.4, 0.9)  # Deep Water blue

var terrain = {
	"water": { 
		"name": "water",
		"percent": water_percent,
		"terrain": "",
		"color": water_colour,
	},
	"deep_water": { 
		"name": "deep_water",
		"terrain": "water",
		"color": deep_water_colour,
	},
	"grass": {
		"name": "grass",
		"percent": grass_percent,
		"terrain": "",
		"color": grass_colour,
	},
}


func InitializeGrass(map):
	var rows = map.size()
	var cols = map[0].size()
	
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"]["name"] == "": 
				map[x][y]["terrain"] = terrain["grass"]


func InitializeDeepWater(map):
	var rows = map.size()
	var cols = map[0].size()
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

				map[x][y]["terrain"] = terrain["deep_water"]


func InitializeWater(map):
	var sum = 0
	var rows = map.size()
	var cols = map[0].size()
	var saturation = rows / 9

	var water_features = []
	var total_water = terrain["water"]["percent"] * cols * rows
	
#	Determine water starting positions
	while sum < total_water:
		var pool_size = randi() % int(total_water/saturation)
		water_features.append(pool_size)
		sum += pool_size
#	print("Water features count: ", water_features.size(), ", Sum: ", sum)

#	Select the first drop for the pool
	var _k = 1
	for feature_size in water_features:
#		print("Building feature: ", _k, ". Feature size: ", feature_size); _k += 1
		
		var potential_list = []
		
		#Find a random map coordinate that isn't already water
		var x = randi() % rows; var y = randi() % cols
		while map[x][y]["terrain"]["name"] != terrain["water"]["terrain"]: x = randi() % rows; y = randi() % cols
		
		map[x][y]["terrain"] = terrain["water"]
		
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
			if potential_list.size() <= 0: break
			var random_potential = potential_list[randi() % potential_list.size()]
			
			#Erase any entry that is already water from our potential
			while true:
#				select a random size for the pool up to a maximum
				if random_potential["terrain"]["name"] == "water": 
					potential_list.erase(random_potential)
					
					if potential_list.size() <= 0: break
					
					random_potential = potential_list[randi() % potential_list.size()]
					continue
				break
			
			if potential_list.size() <= 0: break
			
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
	
			random_potential["terrain"] = terrain["water"]
	
#	print("Water added...")
	
	var _l = 0
	for x in map:
		for y in x:
			if y["terrain"]["name"] == "water":
				_l += 1
#	print(l)
#	print("sum / l = ", l * 1.0 / sum)
#	print("sum / total = ", sum * 1.0 / (map.size() * map[0].size()))
