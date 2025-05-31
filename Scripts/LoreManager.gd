class_name LoreManager
extends Node

var lore_entries: Dictionary = {}

func load_lore() -> void:
    var db = get_node("/root/Main/DatabaseManager")
    if not db:
        push_error("DatabaseManager not found")
        return
    var query = "SELECT theme, intro FROM fantasy"
    var result = db.query(query)
    if result:
        for row in result:
            lore_entries[row["theme"]] = row["intro"]
    else:
        push_error("Failed to load lore from database")

func get_lore_entry(topic: String) -> String:
    return lore_entries.get(topic, "Unknown legend.")