extends Node2D


var berry_bush = preload("res://Dingleberry Bush/berry_bush.tscn")
var Player = preload("res://Player/player.tscn")
var Water = preload("res://Water.tscn")

var map = []
var rows = 35       # Number of rows in the grid
var cols = 75     # Number of columns in the grid
var grid_size = 50.0
var water_percent = 0.25
var rng = RandomNumberGenerator.new()

var grid_colour
var water_colour = Color(0, 0.5, 1)  # Water blue
var grass_colour = Color(0, 0.5, 0.1)  # Dark grass green

var bushes = 3


func tile():
	var random_integer = randi() % 10 
	if random_integer < 9: return "grass"
	if random_integer == 9: return "water" 

# randomly generate a new map
func generate_map():
	for x in rows:
		map.append([])
		for y in cols:
			map[x].append({"terrain": "", "structure": "", "x": x, "y": y})
	
	generate_water_features()
	
	for x in rows:
		for y in cols:
			if map[x][y]["terrain"] != "water": map[x][y]["terrain"] = "grass"
			
	return map

func generate_water_features():
	var potential_list = []
	var total_water = water_percent * cols * rows
	
	var sum = 0
	var water_features = []
	while sum < total_water:
		var temp = randi() % int(total_water/2)
		water_features.append(temp)
		sum += temp
	
	for feature_size in water_features:
		var random_x = randi() % rows
		var random_y = randi() % cols
		if (map[random_x][random_y]["terrain"] == ""): #Else try again
			map[random_x][random_y]["terrain"] = "water"
		if random_x + 1 < rows: potential_list.append(map[random_x + 1][random_y])
		if random_x - 1 >= 0: potential_list.append(map[random_x - 1][random_y])
		if random_y + 1 < cols: potential_list.append(map[random_x][random_y + 1])
		if random_y - 1 >= 0: potential_list.append(map[random_x][random_y - 1])
		
		
		
		var counter = 0
		while true:
			var index = randi() % potential_list.size()
			var randomItem = potential_list[index]
			if randomItem["terrain"] == "water": 
				potential_list.erase(index)
				continue
			
			randomItem["terrain"] = "water"
			if randomItem["x"] + 1 < rows: potential_list.append(map[randomItem["x"] + 1][randomItem["y"]])
			if randomItem["x"] - 1 >= 0: potential_list.append(map[randomItem["x"] - 1][randomItem["y"]])
			if randomItem["y"] + 1 < cols: potential_list.append(map[randomItem["x"]][randomItem["y"] + 1])
			if randomItem["y"] - 1 >= 0: potential_list.append(map[randomItem["x"]][randomItem["y"] - 1])
			
			counter += 1
			if counter > feature_size: break


func generate_bushs(count):
	while count > 0:
		var x = randi() % rows
		var y = randi() % cols
		if map[x][y]["terrain"] == "grass": 
			map[x][y]["structure"] = "bush"
			count -= 1


func place_player():
	var x = randi() % rows
	var y = randi() % cols
	if map[x][y]["terrain"] == "grass" && map[x][y]["structure"] == "": 
		map[x][y]["structure"] = "player"
		return


func _draw():
	for row in range(rows):
		for col in range(cols):
			var x = col * grid_size
			var y = row * grid_size
			if(map[row][col]["terrain"] == "water"): grid_colour = water_colour
			if(map[row][col]["terrain"] == "grass"): grid_colour = grass_colour
			draw_rect(Rect2(x, y, grid_size, grid_size), grid_colour)


func _init():
	map = generate_map()
	generate_bushs(bushes)
	place_player()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(rows):
		for col in range(cols):
			var x = col * grid_size
			var y = row * grid_size
			
			if(map[row][col]["structure"] == "bush"): 
				var berryBushInstance = berry_bush.instantiate()
				berryBushInstance.position = Vector2(x + grid_size/2, y + grid_size/2)
				add_child(berryBushInstance)
			
			if(map[row][col]["structure"] == "player"): 
				var player = Player.instantiate()
				player.position = Vector2(x + grid_size/2, y + grid_size/2)
				add_child(player)
			
			if(map[row][col]["terrain"] == "water"): 
				var water = Water.instantiate()
				water.position = Vector2(x + grid_size/2, y + grid_size/2)
				add_child(water)
