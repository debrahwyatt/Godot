extends Node2D


var berry_bush = preload("res://Dingleberry Bush/berry_bush.tscn")
var Player = preload("res://Player/player.tscn")
var Water = preload("res://Water.tscn")

var map = []
var rows = 25       # Number of rows in the grid
var cols = 50     # Number of columns in the grid
var grid_size = 50.0
var rng = RandomNumberGenerator.new()

var grid_colour
var water = Color(0, 0.5, 1)  # Water blue
var grass = Color(0, 0.5, 0.1)  # Dark grass green

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
			map[x].append({"terrain": tile(), "structure": ""})
	
	return map


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
			if(map[row][col]["terrain"] == "water"): grid_colour = water
			if(map[row][col]["terrain"] == "grass"): grid_colour = grass
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
