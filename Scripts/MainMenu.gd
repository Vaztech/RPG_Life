extends Control
signal start_game
signal open_load_menu
signal open_options

# Drag your actual Button nodes into these slots in the Inspector
@export var new_game_path: NodePath
@export var load_path: NodePath
@export var options_path: NodePath
@export var quit_path: NodePath

var _started := false
var _new_btn: Button
var _load_btn: Button
var _opt_btn: Button
var _quit_btn: Button

func _ready() -> void:
	print("📌 MainMenu _ready")

	_new_btn  = get_node_or_null(new_game_path)
	_load_btn = get_node_or_null(load_path)
	_opt_btn  = get_node_or_null(options_path)
	_quit_btn = get_node_or_null(quit_path)

	if _new_btn:  _new_btn.pressed.connect(_on_new_game_pressed)
	else:         push_warning("Assign 'new_game_path' to your New Game button in the Inspector.")
	if _load_btn: _load_btn.pressed.connect(_on_load_pressed)
	if _opt_btn:  _opt_btn.pressed.connect(_on_options_pressed)
	if _quit_btn: _quit_btn.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed() -> void:
	if _started: return
	_started = true
	print("🚀 Starting New Game...")
	emit_signal("start_game")
	if Engine.has_singleton("GameConfig"):
		GameConfig.reset()
	get_tree().change_scene_to_file("res://Scenes/WorldBuilder.tscn")

func _on_load_pressed() -> void:
	print("📂 Load Game clicked")
	emit_signal("open_load_menu")
	# get_tree().change_scene_to_file("res://Scenes/LoadGame.tscn")  # later

func _on_options_pressed() -> void:
	print("⚙️ Options clicked")
	emit_signal("open_options")
	# %OptionsPanel.visible = true  # if you add one

func _on_quit_pressed() -> void:
	print("🚪 Quit clicked")
	get_tree().quit()
