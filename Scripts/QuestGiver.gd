extends Area2D

var DialogueGenerator = preload("res://Scripts/DialogueGenerator.gd")
@export var faction: String = "neutral"
@onready var dialogue_manager = get_node("/root/Main/DialogueManager")
@export var quest_stub_id: String = ""
@export var icon_texture: Texture2D

@onready var sprite = $Sprite2D
@onready var interaction_prompt = $InteractionPrompt
@onready var quest_label = $QuestLabel

var has_given_quest := false

func _ready() -> void:
	sprite.texture = icon_texture
	interaction_prompt.visible = false
	quest_label.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		interaction_prompt.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		interaction_prompt.visible = false

func _process(delta: float) -> void:
	if interaction_prompt.visible and Input.is_action_just_pressed("ui_accept"):
		if not has_given_quest:
			give_quest()
		else:
			speak()

func give_quest() -> void:
	if quest_stub_id.is_empty():
		push_warning("No quest stub ID assigned to QuestGiver.")
		return

	var qg = QuestGenerator.new()
	var quest = qg.finalize_stub(quest_stub_id, faction)
	if quest:
		QuestManager.add_quest(quest)
		dialogue_manager.start_dialogue([quest["flavor_text"]])
		quest_label.text = "New Quest!"
		quest_label.visible = true
		has_given_quest = true

func speak() -> void:
	var lines = DialogueGenerator.generate_npc_dialogue(faction)
	dialogue_manager.start_dialogue(lines)
