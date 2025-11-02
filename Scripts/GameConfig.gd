extends Node

signal world_options_changed(world_options: Dictionary)
signal character_options_changed(character_options: Dictionary)

const DEFAULT_WORLD := {
	"seed": 0,
	"size": Vector2i(128, 128),
	"world_type": "default",
	"biome_preset": "default",
	"difficulty": "normal",
}

const DEFAULT_CHARACTER := {
	"name": "Adventurer",
	"class_name": "Warrior",
	"stats": {},
	"appearance": {},
	"start_items": [],
}

var world_options: Dictionary = DEFAULT_WORLD.duplicate(true)
var character_options: Dictionary = DEFAULT_CHARACTER.duplicate(true)

func _ready() -> void:
	print("[GameConfig] ready")

func reset() -> void:
	world_options = DEFAULT_WORLD.duplicate(true)
	character_options = DEFAULT_CHARACTER.duplicate(true)
	emit_signal("world_options_changed", world_options)
	emit_signal("character_options_changed", character_options)
	print("[GameConfig] reset")

# --- world helpers ---
func set_world_option(key: String, value) -> void:
	world_options[key] = value
	emit_signal("world_options_changed", world_options)

func get_world_option(key: String, default_value = null) -> Variant:
	return world_options.get(key, default_value)

func set_seed(seed: int) -> void:
	world_options["seed"] = int(seed)
	emit_signal("world_options_changed", world_options)

func randomize_seed() -> int:
	randomize()
	var s: int = int(randi())
	if s == 0:
		s = 1
	world_options["seed"] = s
	emit_signal("world_options_changed", world_options)
	return s

func ensure_seed_nonzero() -> int:
	var s_any: Variant = world_options.get("seed", 0)
	var s: int = int(s_any)
	if s == 0:
		return randomize_seed()
	return s

# --- character helpers ---
func set_character_option(key: String, value) -> void:
	character_options[key] = value
	emit_signal("character_options_changed", character_options)

func get_character_option(key: String, default_value = null) -> Variant:
	return character_options.get(key, default_value)

# --- validation ---
func validate() -> Array:
	var errors: Array = []

	# size may come in as Variant
	var size_any: Variant = world_options.get("size", Vector2i(0, 0))
	if size_any is Vector2i:
		var size: Vector2i = size_any
		if size.x <= 0 or size.y <= 0:
			errors.append("World size must be positive.")
		if size.x > 4096 or size.y > 4096:
			errors.append("World size too large (cap at 4096).")
	else:
		errors.append("World size must be a Vector2i.")

	# seed check
	var seed_any: Variant = world_options.get("seed", 0)
	var seed: int = int(seed_any)
	if seed < 0:
		errors.append("Seed must be >= 0.")

	# name check
	var name_any: Variant = character_options.get("name", "")
	var nm: String = str(name_any).strip_edges()
	if nm.is_empty():
		errors.append("Character name cannot be empty.")

	return errors

# --- save/load helpers ---
func to_dict() -> Dictionary:
	var data: Dictionary = {
		"world": world_options.duplicate(true),
		"character": character_options.duplicate(true),
	}
	if data.has("world") and typeof(data["world"]) == TYPE_DICTIONARY:
		if "size" in data["world"] and typeof(data["world"]["size"]) == TYPE_VECTOR2I:
			var v: Vector2i = data["world"]["size"]
			data["world"]["size"] = [v.x, v.y]
	return data

func from_dict(data: Dictionary) -> void:
	var w: Dictionary = DEFAULT_WORLD.duplicate(true)
	var c: Dictionary = DEFAULT_CHARACTER.duplicate(true)

	if data.has("world") and typeof(data["world"]) == TYPE_DICTIONARY:
		for k in data["world"].keys():
			w[k] = data["world"][k]
	if data.has("character") and typeof(data["character"]) == TYPE_DICTIONARY:
		for k in data["character"].keys():
			c[k] = data["character"][k]

	# size may be Vector2i or [x, y]
	if w.has("size"):
		if typeof(w["size"]) == TYPE_VECTOR2I:
			# ok
			pass
		elif typeof(w["size"]) == TYPE_ARRAY:
			var arr: Array = w["size"]
			if arr.size() >= 2:
				w["size"] = Vector2i(int(arr[0]), int(arr[1]))
			else:
				w["size"] = DEFAULT_WORLD["size"]
		else:
			w["size"] = DEFAULT_WORLD["size"]

	world_options = w
	character_options = c
	emit_signal("world_options_changed", world_options)
	emit_signal("character_options_changed", character_options)

# --- debug ---
func debug_print() -> void:
	print("--- GameConfig ---")
	print("World:", world_options)
	print("Character:", character_options)
	print("------------------")
