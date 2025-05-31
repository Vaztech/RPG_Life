extends Node

class_name DatabaseManager

var db_path: String = "user://game_data.db"
var db: Object

func _ready():
	var SQLiteClass = preload("res://Addons/godot-sqlite/godot-sqlite.gd")  # your actual path
	db = SQLiteClass.new()
	var opened: bool = db.open_db(db_path)
	if opened:
		print("Database opened:", db_path)
	else:
		push_error("Failed to open SQLite database.")