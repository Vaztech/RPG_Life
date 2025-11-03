extends Control
signal start_game
signal open_load_menu
signal open_options

@export var new_game_path: NodePath
@export var load_path: NodePath
@export var options_path: NodePath
@export var quit_path: NodePath

var _started: bool = false
var _new_btn: Button
var _load_btn: Button
var _opt_btn: Button
var _quit_btn: Button

func _ready() -> void:
	print("📌 MainMenu _ready")

	# Resolve explicit paths first
	_new_btn  = get_node_or_null(new_game_path)
	_load_btn = get_node_or_null(load_path)
	_opt_btn  = get_node_or_null(options_path)
	_quit_btn = get_node_or_null(quit_path)

	# Fallback search by visible button text if paths aren't set
	if _new_btn == null:
		_new_btn = _find_button_with_text(self, ["New Game", "New game", "Start", "Start Game"])
	if _load_btn == null:
		_load_btn = _find_button_with_text(self, ["Load", "Load save", "Load Save"])
	if _opt_btn == null:
		_opt_btn = _find_button_with_text(self, ["Options", "Settings"])
	if _quit_btn == null:
		_quit_btn = _find_button_with_text(self, ["Quit", "Exit"])

	# Connect safely (use block if/else)
	if _new_btn:
		_new_btn.pressed.connect(_on_new_game_pressed)
	else:
		push_warning("Assign 'new_game_path' or name the button 'New Game'.")

	if _load_btn:
		_load_btn.pressed.connect(_on_load_pressed)

	if _opt_btn:
		_opt_btn.pressed.connect(_on_options_pressed)

	if _quit_btn:
		_quit_btn.pressed.connect(_on_quit_pressed)

func _find_button_with_text(root: Node, labels: Array[String]) -> Button:
	for child in root.get_children():
		if child is Button:
			var t := (child as Button).text.strip_edges()
			for L in labels:
				if t == L:
					return child
		var found := _find_button_with_text(child, labels)
		if found:
			return found
	return null

func _on_new_game_pressed() -> void:
	if _started:
		return
	_started = true
	print("🚀 Starting New Game...")
	emit_signal("start_game")
	if Engine.has_singleton("GameConfig"):
		GameConfig.reset()
	get_tree().change_scene_to_file("res://Scenes/WorldBuilder.tscn")

func _on_load_pressed() -> void:
	emit_signal("open_load_menu")
	# get_tree().change_scene_to_file("res://Scenes/LoadGame.tscn")

func _on_options_pressed() -> void:
	emit_signal("open_options")
	# show options panel here

func _on_quit_pressed() -> void:
	get_tree().quit()
