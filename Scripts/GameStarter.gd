extends Node
@export var world_node_path: NodePath = NodePath("../World")
@export var player_scene: PackedScene
@export var spawn_position: Vector2 = Vector2(100, 100)

var _started: bool = false

func _ready() -> void:
	await get_tree().process_frame
	if _started: return
	_started = true

	var seed_value: int = GameConfig.ensure_seed_nonzero()
	print("[GameStarter] seed:", seed_value)

	var world: Node = get_node_or_null(world_node_path)
	assert(world != null, "GameStarter: World not found at '%s' (set world_node_path in Inspector)." % [world_node_path])
	assert(world.has_method("generate_from_seed"), "World needs generate_from_seed(seed:int).")

	world.call("generate_from_seed", seed_value)

	if player_scene:
		var p: Node2D = player_scene.instantiate()
		p.name = str(GameConfig.get_character_option("name", "Adventurer"))
		get_tree().current_scene.add_child(p)
		p.global_position = spawn_position
		print("[GameStarter] Player '%s' spawned at %s" % [p.name, str(spawn_position)])
