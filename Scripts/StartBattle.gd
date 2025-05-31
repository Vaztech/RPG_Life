extends Node

# Path to the battle scene
const BATTLE_SCENE_PATH := "res://Scenes/Battle.tscn"

# Example test enemies (can be replaced with your actual enemy instances)
var test_enemies: Array = []

func _ready():
    # You can call this manually or on an event trigger
    start_battle()

func start_battle():
    var battle_scene = load(BATTLE_SCENE_PATH)
    var battle_instance = battle_scene.instantiate()

    # You can set enemies to pass to the battle (optional)
    if battle_instance.has_node("CombatManager"):
        battle_instance.get_node("CombatManager").set_enemies(test_enemies)

    get_tree().root.add_child(battle_instance)
    battle_instance.global_position = Vector2(0, 0)  # Or center it
