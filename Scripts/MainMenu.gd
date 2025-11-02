extends Control
# Expects buttons named: NewGameButton, LoadGameButton, OptionsButton, QuitButton

@onready var new_game_btn: Button  = %NewGameButton
@onready var load_game_btn: Button = %LoadGameButton
@onready var options_btn: Button   = %OptionsButton
@onready var quit_btn: Button      = %QuitButton

func _ready() -> void:
	print("📌 MainMenu _ready")
	if is_instance_valid(new_game_btn):  new_game_btn.pressed.connect(_on_new_game_pressed)
	if is_instance_valid(load_game_btn): load_game_btn.pressed.connect(_on_load_game_pressed)
	if is_instance_valid(options_btn):   options_btn.pressed.connect(_on_options_pressed)
	if is_instance_valid(quit_btn):      quit_btn.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed() -> void:
	print("🟢 New Game clicked")
	GameConfig.reset()  # autoload you just created
	get_tree().change_scene_to_file("res://Scenes/WorldBuilder.tscn")

func _on_load_game_pressed() -> void:
	print("📂 Load Game clicked (stub)")
	# TODO: open your load UI

func _on_options_pressed() -> void:
	print("⚙️ Options clicked (stub)")
	# TODO: open options panel

func _on_quit_pressed() -> void:
	print("🚪 Quit clicked")
	get_tree().quit()
