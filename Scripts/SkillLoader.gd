extends Node
class_name SkillLoader

var skills_data = {}

func _ready():
    load_skills()

func load_skills():
    var file_path = "res://Data/skills.json"
    if not FileAccess.file_exists(file_path):
        push_warning("SkillLoader: skills.json not found at " + file_path)
        return
    var file = FileAccess.open(file_path, FileAccess.READ)
    if file:
        var content = file.get_as_text()
        var result = JSON.parse_string(content)
        if typeof(result) == TYPE_DICTIONARY:
            skills_data = result
        else:
            push_warning("SkillLoader: JSON parse failed or returned unexpected type.")

func get_skills_for_class(class_name: String) -> Array:
    return skills_data.get(class_name, [])
