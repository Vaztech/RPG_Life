class_name StatCalculator
extends Node

func calculate_hp(class_data: Dictionary, stat_dict: Dictionary) -> int:
    var hit_die = class_data.get("hit_die", 6)
    var con_modifier = int((stat_dict.get("Constitution", 10) - 10) / 2)
    var hp = hit_die + con_modifier
    return max(hp, 1)

func calculate_mp(class_data: Dictionary, stat_dict: Dictionary) -> int:
    if not class_data.get("spellcasting", false):
        return 0
    var primary_stat = class_data.get("spellcasting_stat", "Intelligence")
    var stat_value = stat_dict.get(primary_stat, 10)
    return max(int((stat_value - 10) / 2), 0) * 2

func calculate_attack(class_data: Dictionary, stat_dict: Dictionary) -> int:
    var primary_stat = class_data.get("primary_stat", "Strength")
    var modifier = int((stat_dict.get(primary_stat, 10) - 10) / 2)
    return 10 + modifier

func calculate_defense(stat_dict: Dictionary) -> int:
    var dex_modifier = int((stat_dict.get("Dexterity", 10) - 10) / 2)
    return 10 + dex_modifier