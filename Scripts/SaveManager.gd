extends Node

class_name SaveManager

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
