extends Resource

class_name Race

@export var name: String
@export var description: String
@export var traits: Dictionary = {}
@export var subraces: Dictionary = {}

func get_trait(key: String) -> String:
    return traits[key] if traits.has(key) else ""

func get_subrace(subrace_name: String) -> Dictionary:
    return subraces[subrace_name] if subraces.has(subrace_name) else {}