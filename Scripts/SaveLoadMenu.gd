extends Control

@onready var save_slot_1 = $VBox/SaveSlot1
@onready var load_slot_1 = $VBox/LoadSlot1
@onready var save_slot_2 = $VBox/SaveSlot2
@onready var load_slot_2 = $VBox/LoadSlot2
@onready var save_slot_3 = $VBox/SaveSlot3
@onready var load_slot_3 = $VBox/LoadSlot3

@onready var confirm_dialog = $ConfirmDialog
var pending_save_slot := ""

func _ready():
    save_slot_1.pressed.connect(func(): _confirm_overwrite("slot1.json"))
    load_slot_1.pressed.connect(func(): _load_slot("slot1.json"))

    save_slot_2.pressed.connect(func(): _confirm_overwrite("slot2.json"))
    load_slot_2.pressed.connect(func(): _load_slot("slot2.json"))

    save_slot_3.pressed.connect(func(): _confirm_overwrite("slot3.json"))
    load_slot_3.pressed.connect(func(): _load_slot("slot3.json"))

    confirm_dialog.confirmed.connect(_save_confirmed)

func _confirm_overwrite(slot_name: String):
    pending_save_slot = slot_name
    confirm_dialog.dialog_text = "Overwrite save in " + slot_name + "?"
    confirm_dialog.popup_centered()

func _save_confirmed():
    if pending_save_slot != "":
        var player = get_node("/root/Main/Player")  # Adjust path if needed
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
        WorldSaveManager.save_game(game_data, pending_save_slot)
        pending_save_slot = ""

func _load_slot(filename: String):
    var data = WorldSaveManager.load_game(filename)
    if data.is_empty():
        print("⚠️ No save data found.")
        return

    print("✅ Loaded:", data)
    var player = get_node("/root/Main/Player")  # Adjust path
    player.name = data["player"]["name"]
    player.hp = data["player"]["hp"]
    player.mp = data["player"]["mp"]
    player.inventory = data["player"]["inventory"]
    player.equipped_items = data["player"]["equipment"]

    get_tree().change_scene_to_file("res://Scenes/Main.tscn")
