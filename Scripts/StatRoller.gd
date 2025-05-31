class_name StatRoller
extends Node

func roll_d6() -> int:
    return randi() % 6 + 1

func roll_4d6_drop_lowest() -> int:
    var rolls = []
    for i in range(4):
        rolls.append(roll_d6())
    rolls.sort()
    return rolls[1] + rolls[2] + rolls[3]

func roll_stats() -> Array:
    var stats = []
    for i in range(6):
        stats.append(roll_4d6_drop_lowest())
    return stats

func apply_racial_bonuses(stats: Array, bonuses: Dictionary) -> Array:
    var names = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
    var adjusted = stats.duplicate()
    for i in range(names.size()):
        var stat = names[i]
        if bonuses.has(stat):
            adjusted[i] += bonuses[stat]
    return adjusted