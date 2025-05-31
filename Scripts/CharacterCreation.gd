extends Control

@onready var name_input = $NameInput
@onready var class_selector = $ClassSelector
@onready var race_selector = $RaceSelector
@onready var seed_input = $SeedInput

func _on_confirm_button_pressed():
    var selected_name = name_input.text
    var selected_class = class_selector.get_selected_text()
    var selected_race = race_selector.get_selected_text()
    var selected_seed = seed_input.text if seed_input.text != "" else str(randi())

    var gear_loader = GearLoader.new()
    gear_loader.load_gear_data()
    var starting_items = gear_loader.get_starting_items(selected_class)

    var game_data = {
        "player_name": selected_name,
        "class": selected_class,
        "race": selected_race,
        "world_seed": selected_seed,
        "starting_items": starting_items
    }

    GameState.start_game(game_data)