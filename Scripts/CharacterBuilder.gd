extends Control
# Expects controls: NameField (LineEdit), ClassDropdown (OptionButton)
# and buttons: Back, StartGame

@onready var name_field: LineEdit      = %NameField
@onready var class_dd: OptionButton    = %ClassDropdown
@onready var back_btn: Button          = %Back
@onready var start_btn: Button         = %StartGame

func _ready() -> void:
	back_btn.pressed.connect(_go_back)
	start_btn.pressed.connect(_start_game)

func _go_back() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldBuilder.tscn")

func _start_game() -> void:
	var nm := name_field.text.strip_edges()
	if nm == "":
		nm = "Adventurer"
	var cls := class_dd.get_item_text(class_dd.selected)

	GameConfig.set_character_option("name", nm)
	GameConfig.set_character_option("class_name", cls)

	get_tree().change_scene_to_file("res://Scenes/GameWorld.tscn")
