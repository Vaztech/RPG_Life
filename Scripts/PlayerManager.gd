extends Node

class_name PlayerManager

@export var class_manager: Node  # Replace with ClassManager if defined
@export var stat_manager: Node   # Replace with StatManager if defined

var player_data: Dictionary = {}

func _ready():
    player_data = {
        "name": "Hero",
        "level": 1,
        "class": "",
        "stats": stat_manager.initialize_stats()
    }
    print("Initialized player data:", player_data)