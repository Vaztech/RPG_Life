extends Control

@onready var skill_list = $VBoxContainer
@onready var class_name = "Mage"

var skill_loader: SkillLoader
var selected_skill: Dictionary = {}

func _ready():
	skill_loader = SkillLoader.new()
	add_child(skill_loader)
	skill_loader.load_skills()
	show_skills_for_class(class_name)

func show_skills_for_class(class_name: String):
	skill_list.clear()
	var skills = skill_loader.get_skills_for_class(class_name)
	for skill in skills:
		var btn = Button.new()
		btn.text = skill.get("name", "Unnamed Skill")
		btn.pressed.connect(func(): _on_skill_selected(skill))
		skill_list.add_child(btn)

func _on_skill_selected(skill_data: Dictionary):
	selected_skill = skill_data
	print("Selected skill: %s" % skill_data.get("name"))
