extends Node

func _ready():
	print("🧠 GameWorld _ready() called")

	if not has_node("WorldSaveManager"):
		var save_manager = Node.new()
		save_manager.name = "WorldSaveManager"
		add_child(save_manager)
		print("✅ WorldSaveManager created")

	if not has_node("TownGenerator"):
		var town_generator = Node.new()
		town_generator.name = "TownGenerator"
		add_child(town_generator)
		print("✅ TownGenerator created")

func initialize(save_manager, town_generator):
	print("🧩 GameWorld initialized with:", save_manager, town_generator)

func load_world():
	print("🌍 load_world() called")


func get_all_towns() -> Array:
	return [
		{"name": "Eldoria", "position": Vector2i(10, 6)},
		{"name": "Stonehelm", "position": Vector2i(24, 14)}
	]
