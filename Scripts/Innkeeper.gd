extends Area2D

@export var interaction_prompt_scene: PackedScene
@export var inn_ui_scene: PackedScene = preload("res://UI/InnUI.tscn")

var prompt_instance

func _on_body_entered(body):
	if body.name == "Player":
		show_prompt()

func show_prompt():
	if not interaction_prompt_scene: return
	if prompt_instance: return

	prompt_instance = interaction_prompt_scene.instantiate()
	get_tree().get_root().add_child(prompt_instance)
	prompt_instance.set_message("Would you like to rest at the inn?")
	prompt_instance.set_callback(_on_prompt_response)

func _on_prompt_response(accepted: bool):
	if accepted:
		open_inn_ui()
	if prompt_instance:
		prompt_instance.queue_free()
		prompt_instance = null

func open_inn_ui():
	if inn_ui_scene:
		var inn_ui = inn_ui_scene.instantiate()
		get_tree().get_root().add_child(inn_ui)