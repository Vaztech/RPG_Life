class_name CivilizationGenerator
extends Node

@export var race_options := ["Human", "Elf", "Dwarf", "Orc"]
@export var alignment_options := ["Good", "Neutral", "Evil"]

func generate_civilization(id: int) -> Dictionary:
    var civ = {
        "id": id,
        "name": "Civ%d" % id,
        "race": race_options[randi() % race_options.size()],
        "alignment": alignment_options[randi() % alignment_options.size()],
        "capital": "Capital%d" % id,
        "culture": "Traditional"
    }
    return civ

func generate_many(count: int) -> Array:
    var result = []
    for i in range(count):
        result.append(generate_civilization(i + 1))
    return result