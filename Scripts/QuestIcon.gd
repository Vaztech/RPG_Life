extends Sprite2D

@export_enum("available", "in_progress", "ready_to_turn_in") var quest_status := "available"

func _ready():
	update_icon()

func update_icon():
	match quest_status:
		"available":
			texture = preload("res://Assets/Icons/quest_icon_available.png")
		"in_progress":
			texture = preload("res://Assets/Icons/quest_icon_in_progress.png")
		"ready_to_turn_in":
			texture = preload("res://Assets/Icons/quest_icon_turnin.png")
