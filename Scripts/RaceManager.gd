class_name RaceManager
extends Node

var races: Array = []

func _ready():
    load_races()

func load_races():
    var db = get_node("/root/Main/DatabaseManager")
    if not db:
        push_error("DatabaseManager not found")
        return
    var query = """
        SELECT 
            name, description, size, speed, favored_class, languages, racial_traits,
            ability_modifiers_Dexterity AS dex_mod, ability_modifiers_Constitution AS con_mod,
            subraces_High_Elf_description AS high_elf_desc, subraces_High_Elf_ability_modifiers_Intelligence AS high_elf_int_mod
        FROM races
    """
    var result = db.query(query)
    if result:
        for row in result:
            var race = {
                "name": row["name"],
                "description": row["description"],
                "size": row["size"],
                "speed": row["speed"],
                "favored_class": row["favored_class"],
                "languages": JSON.parse_string(row["languages"]) if row["languages"] else [],
                "racial_traits": JSON.parse_string(row["racial_traits"]) if row["racial_traits"] else [],
                "ability_modifiers": {
                    "Dexterity": row["dex_mod"] if row["dex_mod"] else 0,
                    "Constitution": row["con_mod"] if row["con_mod"] else 0
                },
                "subraces": {}
            }
            if row["high_elf_desc"]:
                race["subraces"]["High Elf"] = {
                    "description": row["high_elf_desc"],
                    "ability_modifiers": {
                        "Intelligence": row["high_elf_int_mod"] if row["high_elf_int_mod"] else 0
                    }
                }
            races.append(race)
    else:
        push_error("Failed to load races from database")

func get_race_data(race: String) -> Dictionary:
    for r in races:
        if r.get("name", "").to_lower() == race.to_lower():
            return r
    return {}

func format_modifiers(modifiers: Dictionary) -> String:
    var result = []
    for k in modifiers.keys():
        result.append("%s: %+d" % [k, modifiers[k]])
    return ", ".join(result)