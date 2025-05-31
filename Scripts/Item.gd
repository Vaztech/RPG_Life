extends Resource

# This class is now a lightweight helper for optional use if needed.

class_name Item

var id: String
var name: String
var description: String
var slot: String = ""
var stats: Dictionary = {}
var usable: bool = false
var use_effect: String = ""

func from_dict(data: Dictionary) -> void:
    id = data.get("id", "")
    name = data.get("name", "")
    description = data.get("description", "")
    slot = data.get("slot", "")
    stats = data.get("stats", {})
    usable = data.get("usable", false)
    use_effect = data.get("use_effect", "")

func to_dict() -> Dictionary:
    return {
        "id": id,
        "name": name,
        "description": description,
        "slot": slot,
        "stats": stats,
        "usable": usable,
        "use_effect": use_effect
    }