extends Area2D

@export var inn_ui_scene: PackedScene = preload("res://UI/InnUI.tscn")

var is_in_range := false
var inn_ui: Node = null

@onready var prompt_label := $PromptLabel

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	prompt_label.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		is_in_range = true
		prompt_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		is_in_range = false
		prompt_label.visible = false

func _process(_delta):
	if is_in_range and Input.is_action_just_pressed("ui_accept") and inn_ui == null:
		var player = get_node("/root/Main/Player")
		inn_ui = inn_ui_scene.instantiate()
		inn_ui.set_player(player)
		get_tree().root.add_child(inn_ui)
