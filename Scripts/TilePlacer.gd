extends TileMap

func _ready():
    # Place a test tile at position (0,0)
    set_cell(Vector2i(0, 0), 0, Vector2i(0, 0))
    print("Test tile placed at (0,0)")