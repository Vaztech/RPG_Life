class_name GeographyGenerator
extends Node

@export var width: int = 10
@export var height: int = 10

func generate_map() -> Array:
	var terrain_types = ["Mountain", "Plain", "Desert", "Forest", "River"]
	var map_data = []
	for y in range(height):
		var row = []
		for x in range(width):
			var terrain = terrain_types[randi() % terrain_types.size()]
			row.append({
				"terrain": terrain,
				"elevation": randi() % 100,
				"moisture": randi() % 100
			})
		map_data.append(row)
	return map_data