extends Node2D

var map = []
var rows = 42
var cols = 77
var grid_size = 50.0

var rng = RandomNumberGenerator.new()

var nodes = preload("res://Scenes/Nodes.tscn").instantiate().nodes

var grass = preload("res://Scenes/Grass.tscn").instantiate()
var water = preload("res://Scenes/Water.tscn").instantiate()
var deep_water = preload("res://Scenes/DeepWater.tscn").instantiate()

#var male_name_list = ["Dick", "Roger", "Peter", "Rodney", "Richard", "William", "Willy"]
#var female_name_list = ["Darcy", "Regina", "Petunia", "Rose", "Tabitha", "Wendy", "Milly", "Winnifred"]

func GenerateWorld():
	for x in rows:
		map.append([])
		for y in cols:
			map[x].append({
				"x": x, 
				"y": y,
				"terrain" : {"name": "", "color": Color(0, 0, 0)},
				"structure": {"name": ""},
			})


func _init():
	GenerateWorld()
	water.GenerateWater(map, nodes, rows, cols)
	grass.GenerateGrass(map, nodes, rows, cols)
	deep_water.GenerateDeepWater(map, nodes, rows, cols)
	
	GeneratePlayers(nodes["player"])
	GenerateObj(nodes["structure"]["tree"])
	
#	GenerateObj(nodes["bush"])
#	GenerateLargeobj(nodes["structure"]["mountain"])
#	Generateobj(nodes["big_bushes"])


func _ready():
	for row in range(rows):
		for col in range(cols):
			if map[row][col]["structure"]["name"] == "player": 
				PlacePlayer(row, col)
				continue
			if map[row][col]["terrain"]["name"] in ["water", "deep_water", "grass"]: PlaceTerrain(nodes["terrain"][map[row][col]["terrain"]["name"]], row, col)
			if map[row][col]["structure"]["name"] != "": PlaceObj(nodes["structure"][map[row][col]["structure"]["name"]], row, col)


func _draw():
	for row in range(rows):
		for col in range(cols):
			var grid_colour
			var x = col * grid_size
			var y = row * grid_size
			grid_colour = map[row][col]["terrain"]["color"]
			draw_rect(Rect2(x, y, grid_size, grid_size), grid_colour)


func PlaceTerrain(obj, row, col):
	var x = col * grid_size
	var y = row * grid_size
	var new_obj = obj["node"].instantiate()
	
	new_obj.name = obj["name"].capitalize()
	new_obj.position = Vector2(x + grid_size/2, y + grid_size/2)
	new_obj.SetStructure(obj["code"])
	new_obj.map_coordinates = [x, y]
	add_child(new_obj)
	

func GenerateObj(obj):
	var count = obj["percent"] * cols * rows 
	while count > 0:
		var x = randi() % rows
		var y = randi() % cols
		if map[x][y]["terrain"]["name"] == obj["terrain"] && map[x][y]["structure"]["name"] == "": 
			map[x][y]["structure"] = obj
			count -= 1


func GenerateLargeobj(obj):
	var count = obj["percent"] * cols * rows 
	while count > 0:
		count += GenerateStructure(obj, randi() % rows, randi() % cols)
		


func GenerateStructure(obj, x, y):
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


func GeneratePlayers(obj):
	var count = obj["percent"] * cols * rows 
	while count > 0:
		var x = randi() % rows
		var y = randi() % cols
		if map[x][y]["terrain"]["name"] == obj["terrain"] && map[x][y]["structure"]["name"] == "": 
			map[x][y]["structure"] = obj
			count -= 1
	pass
	

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
