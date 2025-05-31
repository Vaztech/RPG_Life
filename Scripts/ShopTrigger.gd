extends Area2D

@export var shop_type: String = "general"  # E.g., "magic", "blacksmith", etc.

@onready var shop_ui := preload("res://UI/ShopUI.tscn")
@onready var player: Node = null

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player = body
		show_interaction_prompt("Press [E] to open shop")
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player = null
		hide_interaction_prompt()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _process(_delta: float) -> void:
	if player and Input.is_action_just_pressed("interact"):
		var shop_instance = shop_ui.instantiate()
		get_tree().root.add_child(shop_instance)
		shop_instance.open_shop(shop_type)

func show_interaction_prompt(text: String) -> void:
	var prompt := get_tree().root.get_node_or_null("UI/InteractionPrompt")
	if prompt:
		prompt.show_prompt(text)

func hide_interaction_prompt() -> void:
	var prompt := get_tree().root.get_node_or_null("UI/InteractionPrompt")
	if prompt:
		prompt.hide()
