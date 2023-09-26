extends Node2D


var berry_bush = preload("res://Dingleberry Bush/berry_bush.tscn")

var map = []
var rows       # Number of rows in the grid
var cols      # Number of columns in the grid
var grid_size = 50
var rng = RandomNumberGenerator.new()

var grid_colour
var water = Color(0, 0.5, 1)  # Color of the grid lines
var grass = Color(0, 0.5, 0.1)  # Color of the grid lines


func _init():
	map = generate_map()
	rows = map.size()       # Number of rows in the grid
	cols = map[0].size()       # Number of columns in the grid
	

func tile():
	var random_integer = randi() % 10 
	if random_integer < 9: return 'g'
	if random_integer == 9: return 'w' 

# randomly generate a new map
func generate_map():
	for i in 100:
		map.append([])
		for j in 100:
			map[i].append(tile())
	
	return map


func _draw():
	for row in range(rows):
		for col in range(cols):
			var x = col * grid_size
			var y = row * grid_size
			if(map[row][col] == 'w'): grid_colour = water
			if(map[row][col] == 'g'): grid_colour = grass
			draw_rect(Rect2(x, y, grid_size, grid_size), grid_colour)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Define the number of berry bushes you want to spawn
	var numberOfBushesToSpawn = 4

	# Loop to spawn berry bushes randomly
	for i in range(numberOfBushesToSpawn):
		var berryBushInstance = berry_bush.instantiate()
		berryBushInstance.position = Vector2(randi() % 800, randi() % 600)  # Set a random position within your level
		add_child(berryBushInstance)
