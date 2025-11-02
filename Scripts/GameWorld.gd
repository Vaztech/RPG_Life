extends Node
# res://Scripts/GameWorld.gd

# Keep / add any managers you need as children or look them up via autoloads.
# This file’s guarantees:
#  - Provides instance method get_all_towns() the World can query.
#  - Does NOT generate the world here (that happens once in GameStarter.gd).
#  - Logs when the scene is ready so you can see load order.

func _ready() -> void:
	print("🧠 GameWorld _ready()")
	# If you dynamically add managers, do it here:
	# _ensure_child("WorldSaveManager")
	# _ensure_child("TownGenerator")
	# _ensure_child("QuestManager")
	# etc.

# Example helper: creates a plain Node if missing; replace with your real scenes/scripts as needed
func _ensure_child(name: String) -> void:
	if has_node(name): return
	var n := Node.new()
	n.name = name
	add_child(n)
	print("✅ Created child:", name)

# --- API the World.gd expects -----------------------------------------------

func get_all_towns() -> Array:
	# Replace this stub with your real list (e.g., from TownGenerator/JSON/save)
	return [
		{"name": "Eldoria", "position": Vector2i(10, 6)},
		{"name": "Stonehelm", "position": Vector2i(24, 14)},
	]

# If you have more APIs the World or other nodes will call, keep them here as instance methods.
# e.g., func get_biome_rules():, func get_spawn_point():, etc.
