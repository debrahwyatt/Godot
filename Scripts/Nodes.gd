extends Control

var water_saturation = 8
var water_percent = 0.30
var tree_percent = 0.03
var grass_percent = 0.06
var bush_percent = 0.0015
var mountain_percent = 0.01
var player_percent = 0.002

var water_colour = Color(0, 0.5, 1)  # Water blue
var grass_colour = Color(0, 0.5, 0.1)  # Dark grass green
var deep_water_colour = Color(0, 0.4, 0.9)  # Deep Water blue

var nodes = {
	
	"player": { 
		"name": "player",
		"percent": player_percent,
		"terrain": "grass",
		"node": preload("res://Scenes/Player.tscn"),
		"code": "P",
	},

	"terrain": {
		"water": { 
			"name": "water",
			"saturation": water_saturation,
			"percent": water_percent,
			"terrain": "",
#			"node": preload("res://Scenes/Water.tscn"),
			"color": water_colour,
#			"code": "W",
		},
		"deep_water": { 
			"name": "deep_water",
			"terrain": "water",
#			"node": preload("res://Scenes/DeepWater.tscn"),
			"color": deep_water_colour,
#			"code": "DW",
		},
		"grass": {
			"name": "grass",
			"percent": grass_percent,
			"terrain": "",
#			"node": preload("res://Scenes/Grass.tscn"),
			"color": grass_colour,
#			"code": "G",
		},
	},

	"structure": {
		"bush": { 
			"name": "bush",
			"percent": bush_percent,
			"terrain": "grass",
			"node": preload("res://Scenes/Bush.tscn"),
			"code": "B",
		},
		"big_bush": { 
			"name": "big_bush",
			"percent": bush_percent,
			"terrain": "grass",
			"node": preload("res://Scenes/BigBush.tscn"),
			"code": "BB",
		},
		"tree": { 
			"name": "tree",
			"percent": tree_percent,
			"terrain": "grass",
			"node": preload("res://Scenes/Tree.tscn"),
			"code": "T",
		},
		"mountain": { 
			"name": "mountain",
			"percent": mountain_percent,
			"terrain": "grass",
			"node": preload("res://Scenes/Mountain.tscn"),
			"code": "M",
			"structure": [
				[0, 0, 1, 0, 0],
				[0, 0, 1, 1, 0],
				[0, 1, 1, 1, 0],
				[1, 1, 1, 1, 1],
			],
		},
	}
}

