extends Node

class_name StatManager

var base_stats := {
    "Strength": 10,
    "Dexterity": 10,
    "Constitution": 10,
    "Intelligence": 10,
    "Wisdom": 10,
    "Charisma": 10
}

func initialize_stats() -> Dictionary:
    return base_stats.duplicate()

func modify_stat(stats: Dictionary, stat_name: String, amount: int) -> void:
    if stats.has(stat_name):
        stats[stat_name] += amount