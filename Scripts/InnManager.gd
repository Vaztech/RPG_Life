extends Node
# InnManager.gd - Handles inn stays, healing, and time progression

const INN_COST := 50

func sleep_at_inn(player, on_success: Callable = null):
    if player.gold < INN_COST:
        print("Not enough gold!")
        return
    player.gold -= INN_COST
    restore_player(player)
    WorldTime.advance_day()
    WorldSaveManager.save_game()
    if on_success:
        on_success.call()

func restore_player(player):
    player.hp = player.max_hp
    player.mp = player.max_mp
