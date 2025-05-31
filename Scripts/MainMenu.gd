extends Control

signal start_game

@onready var new_game_button = $VBoxContainer/NewGameButton

func _ready():
	print("📌 MainMenu _ready called")
	print("🔍 NewGameButton exists:", new_game_button != null)

	if new_game_button:
		new_game_button.pressed.connect(_on_new_game_button_pressed)
		print("✅ Signal connected")

func _on_new_game_button_pressed():
	print("🟢 New Game button clicked")
	emit_signal("start_game")
