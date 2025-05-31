extends Node

@export var enemy_scene: PackedScene
@export var battle_ui_path: NodePath = "/root/BattleUI"

var player

func trigger_random_encounter(player_ref):
    player = player_ref
    var enemy = enemy_scene.instantiate()
    get_tree().root.add_child(enemy)

    var battle_ui = get_node_or_null(battle_ui_path)
    if battle_ui:
        battle_ui.start_battle(player, enemy)
    else:
        print("BattleUI node not found at path:", battle_ui_path)