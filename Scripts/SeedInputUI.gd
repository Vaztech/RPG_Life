extends CanvasLayer

@onready var input = $Panel/VBoxContainer/LineEdit
@onready var start_button = $Panel/VBoxContainer/StartButton
@onready var random_button = $Panel/VBoxContainer/RandomButton

var world_seed = 0
func _ready():
	start_button.pressed.connect(_on_start_pressed)
	random_button.pressed.connect(_on_random_pressed)

func _on_start_pressed():
	WorldSeedManager.set_seed_from_input(input.text)
	ThemeManager.assign_theme_from_seed(input.text)
	get_tree().change_scene_to_file("res://Scenes/world_test.tscn")

func _on_random_pressed():
	var world_world_seed = WorldSeedManager.generate_random_seed()
	WorldSeedManager.world_world_seed = seed
	ThemeManager.assign_theme_from_seed(str(world_seed))
	get_tree().change_scene_to_file("res://Scenes/world_test.tscn")
