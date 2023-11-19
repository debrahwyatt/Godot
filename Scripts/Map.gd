extends Node2D

var map = []
var Music = false

const map_multiplyer = 10
var rows = 9 * map_multiplyer
var cols = 16 * map_multiplyer
var grid_size = 50.0

var player_count = int(ceil(map_multiplyer / 2.0))

var rng = RandomNumberGenerator.new()

var terrain = preload("res://Scripts/Terrain.gd").new()
var structures = preload("res://Scripts/Structures.gd").new()
var player = preload("res://Scripts/Player.gd").new()

var camera_position = Vector2(0, 0)


func InitializeWorld():
	for x in rows:
		map.append([])
		for y in cols:
			map[x].append({
				"x": x, 
				"y": y,
				"terrain" : {
					"name": "", 
					"color": Color(0, 0, 0)
				},
				"structure": {
					"name": ""
				},
			})


func _init():
	
	print("Initializing world...")
	InitializeWorld()
	
	print("Initializing water...")
	terrain.InitializeWater(map)
	
	print("Initializing deep water...")
	terrain.InitializeDeepWater(map)
	
	print("Initializing grass...")
	terrain.InitializeGrass(map)
	
	print("Initializing trees...")
	InitializeObj(structures.structure["tree"])

	print("Initializing bushes...")
	InitializeObj(structures.structure["bush"])
	
	print("Initializing players...")
	InitializePlayers(player.player)
	
#	GenerateObj(structures.structure["big_bush"])
#	GenerateLargeobj(structures.structure["mountain"])


func _ready():
	$Music.playing = Music
	print("Placing structures and terrain...")
	for row in range(rows):
		for col in range(cols):
			if map[row][col]["structure"]["name"] == "player": 
				PlacePlayer(row, col)
				continue
			if map[row][col]["structure"]["name"] != "": 
				PlaceObj(structures.structure[map[row][col]["structure"]["name"]], row, col)
	
	print("Setting up map camera...")
	$MapCamera.position = camera_position
	$MapCamera.make_current()


func _draw():
	print("Drawing map...")
	for row in range(rows):
		for col in range(cols):
			var grid_colour
			var x = col * grid_size
			var y = row * grid_size
			grid_colour = map[row][col]["terrain"]["color"]
			draw_rect(Rect2(x, y, grid_size, grid_size), grid_colour)
	
	print("Loading complete.")


func PlaceTerrain(obj, row, col):
	var x = col * grid_size
	var y = row * grid_size
	var new_obj = obj["node"].instantiate()
	
	new_obj.name = obj["name"].capitalize()
	new_obj.position = Vector2(x + grid_size/2, y + grid_size/2)
	new_obj.SetStructure(obj["code"])
	new_obj.map_coordinates = [x, y]
	add_child(new_obj)
	

func InitializeObj(obj):
	var count = obj["percent"] * cols * rows 
	while count > 0:
		var x = randi() % rows
		var y = randi() % cols
		if map[x][y]["terrain"]["name"] == obj["terrain"] && map[x][y]["structure"]["name"] == "": 
			map[x][y]["structure"] = obj
			count -= 1


func InitializeLargeobj(obj):
	var count = obj["percent"] * cols * rows 
	while count > 0:
		count += InitializeStructure(obj, randi() % rows, randi() % cols)
		


func InitializeStructure(obj, x, y):
	if map[x][y]["terrain"]["name"] == obj["terrain"] && map[x][y]["structure"]["name"] == "": 
		if \
			x + obj["structure"].size() > rows || \
			y + obj["structure"][0].size() > cols || \
			y - obj["structure"][0].size() <= cols || \
			x - obj["structure"].size() <= rows: return 0
		for k in range(obj["structure"].size()):
			for l in range(obj["structure"][k].size()):
				if obj["structure"][k][l] == 1: 
					map[x + k][y + l]["structure"] = obj["name"]
	return -1


func InitializePlayers(p):
	var random_potential
	var potential_list = []
	
	var x = randi() % rows; var y = randi() % cols
	while map[x][y]["terrain"]["name"] != p["terrain"]: x = randi() % rows; y = randi() % cols
	camera_position = Vector2(y * grid_size, x * grid_size)

#	Create the first list of potential expansion squares
	if x + 1 < rows: potential_list.append(map[x + 1][y])
	if x - 1 >= 0: potential_list.append(map[x - 1][y])
	if y + 1 < cols: potential_list.append(map[x][y + 1])
	if y - 1 >= 0: potential_list.append(map[x][y - 1])
	
	while player_count > 0:
		random_potential = potential_list[randi() % potential_list.size()]
		
		if random_potential["x"] + 1 < rows: potential_list.append(map[random_potential["x"] + 1][random_potential["y"]])
		if random_potential["x"] - 1 >= 0: potential_list.append(map[random_potential["x"] - 1][random_potential["y"]])
		if random_potential["y"] + 1 < cols: potential_list.append(map[random_potential["x"]][random_potential["y"] + 1])
		if random_potential["y"] - 1 >= 0: potential_list.append(map[random_potential["x"]][random_potential["y"] - 1])
		
#		random_potential["terrain"] = terrain.terrain["grass"]
		if random_potential["structure"]["name"] == "":
			random_potential["structure"]["name"] = "player"
			player_count -= 1


func PlaceObj(obj, row, col):
	var new_obj = obj["node"].instantiate()
	
	new_obj.map_coordinates = [row, col]
	new_obj.name = obj["name"].capitalize()
	new_obj.position = Vector2(grid_size * (float(col + 0.5)), grid_size * (float(row + 0.5)))
	
	add_child(new_obj)


func PlacePlayer(row, col):
	var new_player
	
	if randi() % 2 == 0: 
		new_player = preload("res://Scenes/FemalePlayer.tscn").instantiate()
		new_player.initiate(0)
	else: 
		new_player = preload("res://Scenes/MalePlayer.tscn").instantiate()
		new_player.initiate(1)
	
	new_player.position = Vector2(grid_size * (float(col + 0.5)), grid_size * (float(row + 0.5)))
	new_player.map_coordinates = [row, col]
	add_child(new_player)
	
