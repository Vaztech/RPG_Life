extends Node2D

@onready var battle_scene = preload("res://Scenes/Battle.tscn")

func _ready():
    $Button.pressed.connect(start_test_battle)

func start_test_battle():
    var battle_instance = battle_scene.instantiate()

    # Example test enemy
    var test_enemy = preload("res://Scenes/Enemy.tscn").instantiate()
    test_enemy.name = "TestGoblin"
    test_enemy.stats = {
        "hp": 20,
        "attack": 5,
        "defense": 1,
        "name": "Goblin"
    }

    # Inject enemy into CombatManager before adding battle to scene
    battle_instance.get_node("CombatManager").set_enemies([test_enemy])

    get_tree().current_scene.add_child(battle_instance)