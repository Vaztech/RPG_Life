extends Node

var map_size := Vector2i(10, 10)
var terrain_tile_id := 8

func _ready():
	var tilemap = get_parent().get_node("TileMap")
	tilemap.clear()
	for y in range(map_size.y):
		for x in range(map_size.x):
			tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(terrain_tile_id, 0))
	print("🌍 Procedural map rendered.")