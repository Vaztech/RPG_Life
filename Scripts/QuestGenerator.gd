
extends Node

class_name QuestGenerator

var factions_data = []
var world_event_tone = "neutral"

func _ready():
    load_factions()
    load_world_event_tone()

func load_factions():
    var file = FileAccess.open("res://Data/factions.json", FileAccess.READ)
    if file:
        var json = JSON.new()
        var result = json.parse(file.get_as_text())
        if result == OK:
            factions_data = json.data
        file.close()

func load_world_event_tone():
    var file = FileAccess.open("res://Data/world_event.json", FileAccess.READ)
    if file:
        var json = JSON.new()
        var result = json.parse(file.get_as_text())
        if result == OK and "tone" in json.data:
            world_event_tone = json.data["tone"]
        file.close()

func generate_random_quest(faction_name: String = "Neutral") -> Dictionary:
    var faction = factions_data.filter(func(f): return f.name == faction_name)
    if faction.size() == 0:
        faction = factions_data.filter(func(f): return f.name == "Neutral")
    var selected = faction[0]

    var quest_type = selected.quest_types[randi() % selected.quest_types.size()]
    var title = generate_title(selected.style, quest_type)
    var description = generate_description(selected.tone, quest_type)
    var objectives = generate_objectives(quest_type)

    return {
        "title": title,
        "description": description,
        "objectives": objectives,
        "faction": selected.name,
        "tone": world_event_tone + " + " + selected.tone
    }

func generate_title(style: String, quest_type: String) -> String:
    return style.capitalize().replace("_", " ") + " Quest: " + quest_type.replace("_", " ").capitalize()

func generate_description(tone: String, quest_type: String) -> String:
    return "In this " + tone + " mission, you'll be asked to complete a task involving " + quest_type.replace("_", " ") + "."

func generate_objectives(quest_type: String) -> Array:
    return ["Complete objective related to: " + quest_type.replace("_", " ").capitalize()]
