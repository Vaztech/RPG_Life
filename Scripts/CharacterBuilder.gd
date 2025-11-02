extends Control

# Matches your scene:
# CharacterBuilder
# └─ Margin
#    └─ VBoxContainer
#       ├─ NameHBox
#       │  └─ NameField (LineEdit)
#       ├─ ClassHBox
#       │  └─ ClassDropdown (OptionButton)
#       └─ Buttons
#          ├─ Back (Button)
#          └─ Start Game (Button)   <-- note the space in the name

@onready var name_field: LineEdit     = $Margin/VBoxContainer/NameHBox/NameField
@onready var class_dd: OptionButton   = $Margin/VBoxContainer/ClassHBox/ClassDropdown
@onready var back_btn: Button         = $Margin/VBoxContainer/Buttons/Back
# Handle both cases: if you keep the space OR you rename it to StartGame
@onready var start_btn: Button        = (
	get_node_or_null("Margin/VBoxContainer/Buttons/StartGame")
		as Button
		) if get_node_or_null("Margin/VBoxContainer/Buttons/StartGame") != null \
	else $"Margin/VBoxContainer/Buttons/Start Game"

func _ready() -> void:
	back_btn.pressed.connect(_go_back)
	if start_btn:
		start_btn.pressed.connect(_start_game)
	else:
		push_warning("Could not find Start Game button. Rename to 'StartGame' or keep 'Start Game' exactly.")

func _go_back() -> void:
	get_tree().change_scene_to_file("res://Scenes/WorldBuilder.tscn")

func _start_game() -> void:
	var name_text := name_field.text.strip_edges()
	if name_text.is_empty():
		name_text = "Adventurer"
	var class_name := class_dd.get_item_text(class_dd.selected)

	GameConfig.set_character_option("name", name_text)
	GameConfig.set_character_option("class_name", class_name)

	var errs := GameConfig.validate()
	if errs.size() > 0:
		push_warning("Character/world options have issues: %s" % [errs])
		# return

	get_tree().change_scene_to_file("res://Scenes/GameWorld.tscn")
