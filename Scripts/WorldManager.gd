extends Node

var town_building_data := {}

func generate_town_data(seed: int, town_name: String):
	var rng = RandomNumberGenerator.new()
	rng.seed = seed

	var town_bounds = Rect2(Vector2(100, 100), Vector2(800, 600))
	var generator = load("res://Scripts/TownGenerator.gd").new()
	town_building_data[town_name] = generator.generate_building_positions(rng, town_bounds)

func get_buildings_for_town(town_name: String) -> Array:
	if town_name in town_building_data:
		return town_building_data[town_name]
	return []
