class_name Spell
extends Resource

@export var name: String
@export var level: int
@export var school: String
@export var subschool: String
@export var descriptor: Array[String]
@export var casting_time: String
@export var components: Dictionary
@export var spell_range: String
@export var area: String
@export var target: String
@export var duration: String
@export var saving_throw: String
@export var spell_resistance: bool
@export var description: String
@export var classes: Dictionary
@export var mp_cost: int
@export var min_level: int
@export var stat_requirement: Dictionary
@export var primary_stat: String
@export var domain: String

func can_cast(caster_level: int, ability_score: int) -> bool:
    if primary_stat == "" or stat_requirement.is_empty():
        return caster_level >= min_level
    return caster_level >= min_level and ability_score >= stat_requirement.get(primary_stat, 10)

func get_full_description() -> String:
    var desc := "Name: %s\nLevel: %d\nSchool: %s\nCost: %d MP\nDescription: %s" % [name, level, school, mp_cost, description]
    return desc