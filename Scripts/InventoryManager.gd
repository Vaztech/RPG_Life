
extends Node

class_name InventoryManager

var inventory: Array = []
var equipment: Dictionary = {
	"weapon": null,
	"armor": null,
	"accessory": null
}

# Loads items from a flat list
func load_items(item_data: Array):
	inventory = item_data

func add_item(item: Dictionary) -> void:
	inventory.append(item)

func remove_item(index: int) -> void:
	if index >= 0 and index < inventory.size():
		inventory.remove_at(index)

func equip_item(index: int) -> void:
	if index >= 0 and index < inventory.size():
		var item = inventory[index]
		if item.has("slot"):
			var slot = item["slot"]
			var previous = equipment.get(slot)
			equipment[slot] = item
			inventory.remove_at(index)
			if previous != null:
				inventory.append(previous)

func unequip_item(slot: String) -> void:
	if equipment.has(slot) and equipment[slot] != null:
		inventory.append(equipment[slot])
		equipment[slot] = null

func use_item(index: int) -> Dictionary:
	if index >= 0 and index < inventory.size():
		var item = inventory[index]
		if item.has("type") and item["type"] == "consumable":
			inventory.remove_at(index)
			return item
	return {}

func get_equipped_item(slot: String) -> Dictionary:
	return equipment.get(slot, null)

func get_all_items_flat() -> Array:
	return inventory