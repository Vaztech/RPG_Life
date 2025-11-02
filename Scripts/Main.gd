
extends Node

@onready var MainMenuScene = preload("res://Scenes/MainMenu.tscn")
@onready var GameWorld = preload("res://Scenes/GameWorld.tscn")

var menu

func _ready():
	print("✅ Main.gd _ready() called.")
	start_main_menu()

func start_main_menu():
	menu = MainMenuScene.instantiate()
	add_child(menu)
	if menu.has_signal("start_game"):
		print("🔗 MainMenu has 'start_game' signal.")
		var result = menu.start_game.connect(start_game)
		print("📡 Signal connection result:", result)
	else:
		print("❌ 'start_game' signal missing on MainMenu.")
	print("📦 Instantiating MainMenu...")

func start_game():
	print("🚀 Starting New Game...")

	var game_world = GameWorld.instantiate()
	print("📦 GameWorld instantiated:", game_world)

	add_child(game_world)

	var world = game_world.get_node_or_null("World")
	if world:
		print("✅ Found World node at:", world.get_path())
	else:
		print("❌ World node missing in instantiated GameWorld")
