extends Control

@onready var player_panel = $PlayerPanel
@onready var enemy_panel = $EnemyPanel
@onready var attack_button = $AttackButton
@onready var victory_ui = $VictoryUI

var combat_manager = null

func _ready():
	attack_button.pressed.connect(on_attack_pressed)
	victory_ui.visible = false

func set_combatants(player, enemy, manager):
	combat_manager = manager
	player_panel.get_node("Name").text = player.name
	player_panel.get_node("HP").text = "HP: %d / %d" % [player.hp, player.max_hp]
	enemy_panel.get_node("Name").text = enemy.name
	enemy_panel.get_node("HP").text = "HP: %d / %d" % [enemy.hp, enemy.max_hp]

func update_health():
	if combat_manager:
		var player = combat_manager.player
		var enemy = combat_manager.enemy
		player_panel.get_node("HP").text = "HP: %d / %d" % [player.hp, player.max_hp]
		enemy_panel.get_node("HP").text = "HP: %d / %d" % [enemy.hp, enemy.max_hp]

func on_attack_pressed():
	if combat_manager and combat_manager.player and combat_manager.enemy:
		combat_manager.handle_player_attack()
