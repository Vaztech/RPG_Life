class_name EventSimulator
extends Node

@export var event_types := ["War", "Alliance", "Discovery", "Rebellion"]

func generate_event(year: int, civs: Array) -> Dictionary:
    var civ1 = civs[randi() % civs.size()]
    var civ2 = civs[randi() % civs.size()]
    while civ1 == civ2:
        civ2 = civs[randi() % civs.size()]
    return {
        "year": year,
        "type": event_types[randi() % event_types.size()],
        "involved": [civ1["name"], civ2["name"]],
        "description": "In year %d, a major event occurred between %s and %s." % [year, civ1["name"], civ2["name"]]
    }

func simulate_years(start_year: int, end_year: int, civs: Array) -> Array:
    var events = []
    for year in range(start_year, end_year + 1):
        if randi() % 3 == 0:
            events.append(generate_event(year, civs))
    return events