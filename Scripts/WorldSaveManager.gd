extends Node

var save_path := "user://save_world.json"

var world_seed: int = 0
var modified_chunks := {}

func save_world():
	var data = {
		"seed": world_seed,
		"modified_chunks": modified_chunks
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("World saved to ", save_path)

func load_world():
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return false

	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if typeof(result) == TYPE_DICTIONARY:
		world_seed = result.get("seed", 0)
		modified_chunks = result.get("modified_chunks", {})
		print("World loaded from save.")
		return true
	else:
		print("Failed to parse save file.")
		return false

func mark_chunk_modified(chunk_coords: Vector2i, changes: Dictionary):
	var key = str(chunk_coords.x) + "_" + str(chunk_coords.y)
	if not modified_chunks.has(key):
		modified_chunks[key] = {}
	modified_chunks[key].merge(changes, true)

static func save_quests(quests: Array) -> void:
	var quest_data = []
	for quest in quests:
		quest_data.append({
			"name": quest.name,
			"description": quest.description,
			"objectives": quest.objectives,
			"is_completed": quest.is_completed,
			"is_abandoned": quest.is_abandoned,
			"is_pinned": quest.is_pinned,
		})
	var file = FileAccess.open("user://quests.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(quest_data, "\t"))
	file.close()
static func load_quests() -> Array:
	var quests = []
	if not FileAccess.file_exists("user://quests.json"):
		return quests
	var file = FileAccess.open("user://quests.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var result = JSON.parse_string(text)
	if typeof(result) == TYPE_ARRAY:
		for data in result:
			var quest = {
				"name": data.get("name", ""),
				"description": data.get("description", ""),
				"objectives": data.get("objectives", []),
				"is_completed": data.get("is_completed", false),
				"is_abandoned": data.get("is_abandoned", false),
				"is_pinned": data.get("is_pinned", false),
			}
			quests.append(quest)
	return quests