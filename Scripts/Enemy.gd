extends CharacterBody2D

@export var name: String = "Goblin"
@export var max_hp: int = 6
@export var current_hp: int = 6
@export var attack_power: int = 2
@export var xp_reward: int = 10

var player_node := null

func _ready():
	print("👾 %s spawned with %d HP" % [name, max_hp])
	player_node = get_node_or_null("/root/GameWorld/Player")

func attack(target):
	if target and target.has_method("receive_damage"):
		print("⚔️ %s attacks %s for %d damage!" % [name, target.name, attack_power])
		target.receive_damage(attack_power)

func receive_damage(amount: int):
	current_hp -= amount
	print("💢 %s took %d damage! HP: %d/%d" % [name, amount, current_hp, max_hp])
	if current_hp <= 0:
		die()

func die():
	print("💀 %s has been defeated!" % name)
	if player_node:
		player_node.award_experience(xp_reward)
	queue_free()

func take_turn():
	if player_node:
		attack(player_node)