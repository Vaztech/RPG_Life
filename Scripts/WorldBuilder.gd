extends Control
# Expects controls: SeedField (LineEdit), Width (SpinBox), Height (SpinBox), WorldType (OptionButton)
# and buttons: Back, Continue

@onready var seed_field: LineEdit    = %SeedField
@onready var width_spin: SpinBox     = %Width
@onready var height_spin: SpinBox    = %Height
@onready var type_dd: OptionButton   = %WorldType
@onready var back_btn: Button        = %Back
@onready var continue_btn: Button    = %Continue

func _ready() -> void:
	back_btn.pressed.connect(_go_back)
	continue_btn.pressed.connect(_continue)

func _go_back() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _continue() -> void:
	var seed := 0
	var txt := seed_field.text.strip_edges()
	if txt != "":
		seed = int(txt)  # 0 means "randomize on start"

	var sz := Vector2i(int(width_spin.value), int(height_spin.value))
	var wt := type_dd.get_item_text(type_dd.selected)

	GameConfig.set_world_option("seed", seed)
	GameConfig.set_world_option("size", sz)
	GameConfig.set_world_option("world_type", wt)

	get_tree().change_scene_to_file("res://Scenes/CharacterBuilder.tscn")
