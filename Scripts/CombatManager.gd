extends Node

class_name CombatManager

signal combat_started
signal combat_ended(victory: bool)

var player
var enemies = []
var current_turn_index = 0
var is_player_turn = true

func start_combat(player_ref, enemy_list):
	player = player_ref
	enemies = enemy_list
	current_turn_index = 0
	is_player_turn = true
	emit_signal("combat_started")
	process_turn()

func process_turn():
	if is_player_turn:
		# Wait for player input externally via BattleUI
		pass
	else:
		if current_turn_index < enemies.size():
			var enemy = enemies[current_turn_index]
			if enemy and enemy.is_alive():
				enemy.take_turn(player)
			current_turn_index += 1
			await get_tree().create_timer(0.5).timeout
			process_turn()
		else:
			is_player_turn = true
			current_turn_index = 0

func end_player_turn():
	is_player_turn = false
	process_turn()

func check_combat_end():
	if not player or not player.is_alive():
		emit_signal("combat_ended", false)
	elif enemies.all(func(e): return not e.is_alive()):
		emit_signal("combat_ended", true)

func on_enemy_defeated():
	check_combat_end()
