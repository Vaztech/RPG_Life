extends Node2D

@export var tile_map_layer: TileMapLayer
@export var debug_size := Vector2i(10, 10)

func _ready():
    if tile_map_layer:
        # Fill the grid with first available tile
        var source_id = tile_map_layer.tile_set.get_source_id(0)
        if source_id != -1:
            for x in range(debug_size.x):
                for y in range(debug_size.y):
                    tile_map_layer.set_cell(Vector2i(x, y), source_id, Vector2i.ZERO)
        
        # Print debug info
        print("TileMapLayer debug:")
        print("TileSet sources: ", tile_map_layer.tile_set.get_source_count())
        print("Used cells: ", tile_map_layer.get_used_cells().size())