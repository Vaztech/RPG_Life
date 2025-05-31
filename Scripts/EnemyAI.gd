extends Node
class_name EnemyAI

@export var max_hp := 8
@export var current_hp := 8
@export var attack_power := 1
@export var name := "Enemy"

signal enemy_turn_complete

func take_turn(player_ref):
	if current_hp <= 0:
		print("%s is defeated." % name)
		emit_signal("enemy_turn_complete")
		return

	print("%s attacks!" % name)
	if player_ref and player_ref.has_method("receive_damage"):
		player_ref.receive_damage(attack_power)
	else:
		print("⚠️ Player reference or damage handler missing.")

	await get_tree().create_timer(0.5).timeout
	emit_signal("enemy_turn_complete")