extends Node

var quests := []
var completed_quests := []
var failed_quests := []
var pinned_quests := []

func _ready():
	load_quests()

func add_quest(quest: Dictionary) -> void:
	if not quests.any(func(q): return q.id == quest.id):
		quests.append(quest)
		save_quests()

func complete_quest(quest_id: String) -> void:
	for i in range(quests.size()):
		if quests[i].id == quest_id:
			completed_quests.append(quests[i])
			quests.remove_at(i)
			unpin_quest(quest_id)
			save_quests()
			var popup = get_tree().root.get_node("GameWorld/QuestCompletePopup")
			if popup:
				popup.show_popup("Quest Complete: " + quest_id)

			break

func fail_quest(quest_id: String) -> void:
	for i in range(quests.size()):
		if quests[i].id == quest_id:
			failed_quests.append(quests[i])
			quests.remove_at(i)
			unpin_quest(quest_id)
			save_quests()
			break

func pin_quest(quest_id: String) -> void:
	if quest_id not in pinned_quests:
		pinned_quests.append(quest_id)
		save_quests()

func unpin_quest(quest_id: String) -> void:
	if quest_id in pinned_quests:
		pinned_quests.erase(quest_id)
		save_quests()

func is_quest_pinned(quest_id: String) -> bool:
	return quest_id in pinned_quests

func get_quest_by_id(quest_id: String) -> Dictionary:
	for quest in quests:
		if quest.id == quest_id:
			return quest
	return {}

func load_quests() -> void:
	var path = "res://Data/quests.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var result = JSON.parse_string(file.get_as_text())
		if result is Dictionary:
			quests = result.get("quests", [])
			completed_quests = result.get("completed_quests", [])
			failed_quests = result.get("failed_quests", [])
			pinned_quests = result.get("pinned_quests", [])
		file.close()

func save_quests() -> void:
	var path = "res://Data/quests.json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var data = {
		"quests": quests,
		"completed_quests": completed_quests,
		"failed_quests": failed_quests,
		"pinned_quests": pinned_quests
	}
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
