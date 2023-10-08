extends Node2D

var map = []
var rows = 42
var cols = 77
var grid_size = 50.0

var rng = RandomNumberGenerator.new()

var water_colour = Color(0, 0.5, 1)  # Water blue
var grass_colour = Color(0, 0.5, 0.1)  # Dark grass green
var deep_water_colour = Color(0, 0.4, 0.9)  # Deep Water blue

var water_saturation = 4

var water_percent = 0.3
var tree_percent = 0.06
var grass_percent = 0.06
var bush_percent = 0.0015

var nodes = {
	"waters": { 
		"name": "water",
		"saturation": water_saturation,
		"percent": water_percent,
		"terrain": "",
		"node": preload("res://Scenes/Water.tscn"),
		"color": water_colour,
	},
	"grasses": {
		"name": "grass",
		"percent": grass_percent,
		"terrain": "",
#		"node": preload("res://Dingleberry Bush/berry_bush.tscn"),
		"color": grass_colour,
	},
	"bushes": { 
		"name": "bush",
		"percent": bush_percent,
		"terrain": "grass",
		"node": preload("res://Scenes/Bush.tscn"),
	},
	"big_bushes": { 
		"name": "big_bush",
		"percent": bush_percent,
		"terrain": "grass",
		"node": preload("res://Scenes/BigBush.tscn"),
	},
	"trees": { 
		"name": "tree",
		"percent": tree_percent,
		"terrain": "grass",
		"node": preload("res://Scenes/Tree.tscn"),
	},
	"players": { 
		"name": "player",
		"terrain": "grass",
		"node": preload("res://Scenes/Player.tscn"),
	},
}


func GenerateWorld():
	for x in rows:
		map.append([])
		for y in cols:
			map[x].append({"terrain": "", "structure": "", "x": x, "y": y})


# randomly generate a new map
func GenerateTerrain():
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"] == "": map[x][y]["terrain"] = "grass"


func GenerateWater(waters):
	var sum = 0
	var potential_list = []
	var water_features = []
	var total_water = waters["percent"] * cols * rows
	print(total_water)
	
#	Determine water starting positions
	var n = 0
	while sum < total_water:
		var pool_size = randi() % int(total_water/waters["saturation"])
		print(pool_size)
		water_features.append(pool_size)
		sum += pool_size
	
#	Select the first drop for the pool
	for feature_size in water_features:
		var random_x = randi() % rows
		var random_y = randi() % cols
		if (map[random_x][random_y]["terrain"] == waters["terrain"]): map[random_x][random_y]["terrain"] = waters["name"]
		
#		Create the first list of potential expansion squares
		if random_x + 1 < rows: potential_list.append(map[random_x + 1][random_y])
		if random_x - 1 >= 0: potential_list.append(map[random_x - 1][random_y])
		if random_y + 1 < cols: potential_list.append(map[random_x][random_y + 1])
		if random_y - 1 >= 0: potential_list.append(map[random_x][random_y - 1])
		
#		Select the next available squares and loop it
		for i in feature_size:
			var index = randi() % potential_list.size()
			var random_potential = potential_list[index]
			
			#Erase any entry that is already water from our potential
			while true:
#				select a random size for the pool up to a maximum
				index = randi() % potential_list.size()
				random_potential = potential_list[index]
				if random_potential["terrain"] == waters["name"]: 
					potential_list.erase(index)
					continue
				break


			
#			Paint water wherever we like

				
			random_potential["terrain"] = waters["name"]
			if random_potential["x"] + 1 < rows: potential_list.append(map[random_potential["x"] + 1][random_potential["y"]])
			if random_potential["x"] - 1 >= 0: potential_list.append(map[random_potential["x"] - 1][random_potential["y"]])
			if random_potential["y"] + 1 < cols: potential_list.append(map[random_potential["x"]][random_potential["y"] + 1])
			if random_potential["y"] - 1 >= 0: potential_list.append(map[random_potential["x"]][random_potential["y"] - 1])
			n += 1
	print(n)

func deep_water():
	var water_types = ["water", "deep_water"]
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"] == "water":
				if y - 2 >= 0 and (map[x][y - 1]["terrain"] not in water_types || map[x][y - 2]["terrain"] not in water_types): continue
				if x - 2 >= 0 and (map[x - 1][y]["terrain"] not in water_types || map[x - 2][y]["terrain"] not in water_types): continue
				if x + 2 < rows and (map[x + 1][y]["terrain"] not in water_types || map[x + 2][y]["terrain"] not in water_types): continue
				if y + 2 < rows and (map[x][y + 1]["terrain"] not in water_types || map[x][y + 2]["terrain"] not in water_types): continue

				# Check if deep water isn't touching off the map
				if (x + 1 < rows) && (y + 1 < cols) && (x - 1 >= 0) && (y - 1 >= 0):
					if (map[x - 1][y - 1]["terrain"] not in water_types): continue
					if (map[x - 1][y + 1]["terrain"] not in water_types): continue
					if (map[x + 1][y + 1]["terrain"] not in water_types): continue
					if (map[x + 1][y - 1]["terrain"] not in water_types): continue

				map[x][y]["terrain"] = "deep_water"


func Generate_Random_Object(object):
	var count = object["percent"] * cols * rows 
	while count > 0:
		var x = randi() % rows
		var y = randi() % cols
		if map[x][y]["terrain"] == object["terrain"] && map[x][y]["structure"] == "": 
			map[x][y]["structure"] = object["name"]
			count -= 1


func SpawnPlayer(players):
	var x = randi() % rows
	var y = randi() % cols
	if map[x][y]["terrain"] == "grass" && map[x][y]["structure"] == "": 
		map[x][y]["structure"] = players["name"]
		return


func _draw():
	for row in range(rows):
		for col in range(cols):
			var grid_colour
			var x = col * grid_size
			var y = row * grid_size
			if(map[row][col]["terrain"] == "grass"): grid_colour = grass_colour
			if(map[row][col]["terrain"] == "water"): grid_colour = water_colour
			if(map[row][col]["terrain"] == "deep_water"): grid_colour = deep_water_colour
			draw_rect(Rect2(x, y, grid_size, grid_size), grid_colour)

var count2 = 0

func PlaceObject(object, row, col, x, y):
	if(map[row][col]["structure"] == object["name"]):
		var new_object = object["node"].instantiate()
		new_object.position = Vector2(x + grid_size/2, y + grid_size/2)
		new_object.map_coordinates = [row, col]
		new_object.name = object["name"].capitalize() + str(count2)
		count2 += 1
		add_child(new_object)


func _init():
	GenerateWorld()
	GenerateWater(nodes["waters"])
	deep_water()
	GenerateTerrain()
	Generate_Random_Object(nodes["bushes"])
#	Generate_Random_Object(nodes["big_bushes"])
	Generate_Random_Object(nodes["trees"])
	SpawnPlayer(nodes["players"])


func _ready():
	for row in range(rows):
		for col in range(cols):
			var x = col * grid_size
			var y = row * grid_size
			
			PlaceObject(nodes["bushes"], row, col, x, y)
#			PlaceObject(nodes["big_bushes"], row, col, x, y)			
			PlaceObject(nodes["trees"], row, col, x, y)
			PlaceObject(nodes["players"], row, col, x, y)
			PlaceObject(nodes["waters"], row, col, x, y)
