extends Node

var tree_percent = 0.03
var bush_percent = 0.001
var mountain_percent = 0.01
var player_percent = 0.002

var structure = {
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

