extends Control

@onready var confirm_button = $ConfirmButton
@onready var dialog_label = $DialogLabel

var player

func _ready():
	confirm_button.pressed.connect(_on_confirm_pressed)

func set_player(player_ref):
	player = player_ref

func _on_confirm_pressed():
	if not player:
		print("⚠️ Player reference not set.")
		return

	player.hp = player.max_hp
	player.mp = player.max_mp
	WorldTime.advance_hours(8)

	var game_data := {
		"player": {
			"name": player.name,
			"hp": player.hp,
			"mp": player.mp,
			"level": player.level,
			"inventory": player.inventory,
			"equipment": player.equipped_items
		},
		"location": player.global_position,
		"time": WorldTime.get_time()
	}

	WorldSaveManager.save_game(game_data, "autosave.json")
	dialog_label.text = "You feel well-rested. Game autosaved!"
