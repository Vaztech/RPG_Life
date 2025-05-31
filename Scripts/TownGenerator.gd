extends Node2D

@export var town_radius := 10
@export var town_seed := 0
@export var town_name := "UnnamedTown"

var rng = RandomNumberGenerator.new()
var building_scenes = {}
var used_positions = []

func _ready():
	town_seed = hash(town_name)
	rng.seed = town_seed
	load_building_data()
	generate_town_layout()

func load_building_data():
	var file = FileAccess.open("res://Data/buildings.json", FileAccess.READ)
	if file == null:
		push_error("Failed to load buildings.json")
		return

	var json_text = file.get_as_text()
	var result = JSON.parse_string(json_text)

	if typeof(result) != TYPE_DICTIONARY:
		push_error("Invalid JSON format in buildings.json")
		return

	building_scenes = result

func generate_town_layout():
	used_positions.clear()
	var town_center = Vector2(rng.randi_range(-5, 5), rng.randi_range(-5, 5)) * 32

	for building_name in building_scenes.keys():
		var data = building_scenes[building_name]
		var scene_path = data.get("scene", "")
		var max_count = data.get("max_count", 1)
		var min_distance = data.get("min_distance", 2)

		if scene_path == "":
			continue

		for i in range(max_count):
			var attempts = 0
			var placed = false

			while attempts < 30 and not placed:
				var offset = Vector2(rng.randf_range(-town_radius, town_radius), rng.randf_range(-town_radius, town_radius)).round() * 32
				var town_pos = town_center + offset

				if is_tile_pos_valid(town_pos, min_distance):
					var scene = load(scene_path)
					if scene:
						var instance = scene.instantiate()
						instance.position = town_pos
						add_child(instance)
						used_positions.append(town_pos)
						placed = true
				attempts += 1

func is_tile_pos_valid(tile_pos: Vector2, min_distance: int) -> bool:
	for used_pos in used_positions:
		if tile_pos.distance_to(used_pos) < min_distance * 32:
			return false
	return true
