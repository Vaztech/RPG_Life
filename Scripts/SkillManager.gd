extends Node
class_name SkillManager

var skills := {}

func _ready():
    load_skills()

func load_skills():
    var path = "res://Data/skills.json"
    if not FileAccess.file_exists(path):
        push_error("skills.json not found at: " + path)
        return

    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var raw_text = file.get_as_text()
        var json = JSON.new()
        var result = json.parse(raw_text)
        if result == OK:
            skills = json.get_data()
        else:
            push_error("Failed to parse skills.json: " + json.get_error_message())
        file.close()

func get_skills_for_class(class_name: String, level: int) -> Array:
    if not skills.has(class_name):
        return []

    var result := []
    var class_data = skills[class_name]
    for level_key in class_data.keys():
        if level_key.begins_with("level_"):
            var level_num = int(level_key.replace("level_", ""))
            if level_num <= level:
                result += class_data[level_key]
    return result

func get_skill_by_name(class_name: String, skill_name: String) -> Dictionary:
    if not skills.has(class_name):
        return {}

    var class_data = skills[class_name]
    for level_key in class_data:
        for skill in class_data[level_key]:
            if skill.has("name") and skill["name"] == skill_name:
                return skill
    return {}

func has_skill(class_name: String, skill_name: String, level: int) -> bool:
    var skill = get_skill_by_name(class_name, skill_name)
    if skill.empty():
        return false
    return level >= int(skill.get("min_level", 0))