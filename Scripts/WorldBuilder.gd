extends Control

# Matches your scene:
# WorldBuilder
# └─ MarginContainer
#    └─ VBoxContainer
#       ├─ SeedHBox
#       │  └─ SeedField (LineEdit)
#       ├─ SizeHBox
#       │  ├─ Width (SpinBox)
#       │  └─ Height (SpinBox)
#       ├─ TypeHBox
#       │  └─ WorldType (OptionButton)
#       └─ Buttons
#          ├─ Back (Button)
#          └─ Continue (Button)

@onready var seed_field: LineEdit  = $MarginContainer/VBoxContainer/SeedHBox/SeedField
@onready var width_spin: SpinBox   = $MarginContainer/VBoxContainer/SizeHBox/Width
@onready var height_spin: SpinBox  = $MarginContainer/VBoxContainer/SizeHBox/Height
@onready var type_dd: OptionButton = $MarginContainer/VBoxContainer/TypeHBox/WorldType
@onready var back_btn: Button      = $MarginContainer/VBoxContainer/Buttons/Back
@onready var cont_btn: Button      = $MarginContainer/VBoxContainer/Buttons/Continue

func _ready() -> void:
	back_btn.pressed.connect(_go_back)
	cont_btn.pressed.connect(_continue)

func _go_back() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _continue() -> void:
	# 0 = randomize later
	var seed_text := seed_field.text.strip_edges()
	var seed_value: int = 0
	if not seed_text.is_empty():
		seed_value = int(seed_text)

	var w := int(width_spin.value)
	var h := int(height_spin.value)
	var world_size := Vector2i(max(1, w), max(1, h))
	var world_type := type_dd.get_item_text(type_dd.selected)

	GameConfig.set_world_option("seed", seed_value)
	GameConfig.set_world_option("size", world_size)
	GameConfig.set_world_option("world_type", world_type)

	var errs := GameConfig.validate()
	if errs.size() > 0:
		push_warning("World options have issues: %s" % [errs])
		# return  # uncomment to force fixing before continuing

	get_tree().change_scene_to_file("res://Scenes/CharacterBuilder.tscn")
