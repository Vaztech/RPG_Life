extends Node
# Attach this to a child node named "GameStarter" under GameWorld in GameWorld.tscn

@export var player_scene: PackedScene
@export var spawn_position: Vector2 = Vector2(100, 100)

func _ready() -> void:
	# Give siblings a frame to enter tree / run _ready / register groups
	await get_tree().process_frame   # <-- no parentheses

	var seed_value: int = GameConfig.ensure_seed_nonzero()
	print("[GameStarter] seed:", seed_value)

	var world: Node = null

	# 1) Try sibling path first
	world = get_node_or_null("../World")
	if world:
		print("[GameStarter] Found world by path:", world.get_path())
	else:
		# 2) Fallback to group lookup (World.gd should add itself in _enter_tree)
		world = get_tree().get_first_node_in_group("world_root")
		if world:
			print("[GameStarter] Found world by group:", world.get_path())

	assert(world != null, "World not found. Ensure GameWorld/World has World.gd attached and adds itself to 'world_root'.")
	assert(world.has_method("generate_from_seed"), "World is missing generate_from_seed().")

	world.call("generate_from_seed", seed_value)

	# Optional: spawn player if assigned
	if player_scene:
		var player_instance := player_scene.instantiate()
		var chosen_name: String = str(GameConfig.get_character_option("name", "Adventurer"))
		player_instance.name = chosen_name
		get_tree().current_scene.add_child(player_instance)
		player_instance.global_position = spawn_position
		print("[GameStarter] Player spawned at", spawn_position)
