extends Node


func GenerateDeepWater(map, rows, cols, terrain):
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
