extends Node

class_name Leveling

func get_xp_for_level(level: int) -> int:
    return level * 100

func should_level_up(current_xp: int, current_level: int) -> bool:
    return current_xp >= get_xp_for_level(current_level + 1)

func apply_level_up(character) -> void:
    character.level += 1
    character.stats["Strength"] += 1
    character.stats["Dexterity"] += 1
    character.stats["Constitution"] += 1