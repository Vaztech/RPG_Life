
extends Area2D

@export var npc_name = "Generic NPC"
@export var faction = "Villagers"
@export var role = "villager"

@onready var dialogue_manager = get_node("/root/GameWorld/DialogueManager")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		var world_state = "post-plague"
		dialogue_manager.start_dialogue(faction, role, world_state)
