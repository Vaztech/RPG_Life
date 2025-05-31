extends Control

@onready var tab_container = $TabContainer
@onready var inventory_ui = $TabContainer/Inventory/InventoryUI

func _ready():
	visible = false
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible
		if visible:
			get_tree().paused = true
		else:
			get_tree().paused = false
