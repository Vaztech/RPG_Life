
extends Node

var current_dialogue_lines := []
var current_index := 0

@onready var dialogue_label = $"../DialogueUI/DialogueLabel"

func start_dialogue(npc_faction: String, npc_role: String, world_state: String):
	current_dialogue_lines.clear()
	var data = DialogueGenerator.generate_dialogue(npc_faction, npc_role, world_state)
	current_dialogue_lines = [data["greeting"], data["idle"], data["farewell"]]
	current_index = 0
	show_next_line()

func show_next_line():
	if current_index < current_dialogue_lines.size():
		dialogue_label.text = current_dialogue_lines[current_index]
		current_index += 1
	else:
		end_dialogue()

func end_dialogue():
	dialogue_label.text = ""
