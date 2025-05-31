extends CanvasLayer

@onready var item_container = $Control/Panel/ScrollContainer/ItemListContainer
var item_row_scene = preload("res://UI/ItemRow.tscn")

func update_inventory(items: Array):
	item_container.queue_free_children()
	for item in items:
		var row = item_row_scene.instantiate()
		row.get_node("ItemName").text = item.capitalize()
		item_container.add_child(row)

func _input(event):
	if event.is_action_pressed("inventory_toggle"):
		self.visible = !self.visible