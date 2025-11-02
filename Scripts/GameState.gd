extends Node

func start_game(data: Dictionary):
	var seed = data.get("world_seed", randi())
	WorldGenerator.generate_from_seed(seed)

	var player_scene = preload("res://Scenes/Player.tscn")
	var player = player_scene.instantiate()
	player.name = data.get("player_name", "Adventurer")

	if player.has_method("add_items"):
		var items = data.get("starting_items", [])
		player.add_items(items)

	get_tree().current_scene.add_child(player)
	player.global_position = Vector2(100, 100)  # Replace with spawn point logic
