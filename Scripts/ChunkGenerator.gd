extends Node2D

@onready var tilemap: TileMap = $TileMap

@export var chunk_coords := Vector2i.ZERO
@export var world_seed: int = 0

var chunk_size := Vector2i(16, 16)

const BIOME_TILES = {
	"forest": 0,
	"desert": 1,
	"snow": 2,
	"swamp": 3,
	"mountain": 4,
	"ocean": 5
}

const STRUCTURE_TILES = {
	"town": 6,
	"dungeon": 7,
	"river": 8
}

func _ready():
	BiomeManager.configure(world_seed)
	# tilemap.modulate = ThemeManager.palette  # ThemeManager not defined

	generate_chunk()

func generate_chunk():
	var rng = RandomNumberGenerator.new()
	var combined_seed = hash(chunk_coords + Vector2i(world_seed, 42))
	rng.seed = combined_seed

	for x in chunk_size.x:
		for y in chunk_size.y:
			var global_x = (chunk_coords.x * chunk_size.x) + x
			var global_y = (chunk_coords.y * chunk_size.y) + y
			var biome = BiomeManager.get_biome_at(global_x, global_y)
			if BIOME_TILES.has(biome):
				var tile_id = BIOME_TILES[biome]
				tilemap.set_cell(0, Vector2i(x, y), tile_id)

	# STRUCTURE LOGIC (one per chunk)
	if chunk_coords.x % 8 == 0 and chunk_coords.y % 6 == 0:
		place_structure("town", rng)
	elif chunk_coords.y == 0 and rng.randf() < 0.4:
		place_structure("river", rng)
	elif abs(chunk_coords.x + chunk_coords.y) % 9 == 0:
		place_structure("dungeon", rng)

func place_structure(type: String, rng: RandomNumberGenerator):
	if not STRUCTURE_TILES.has(type):
		return

	var tile_id = STRUCTURE_TILES[type]
	var pos = Vector2i(
		rng.randi_range(2, chunk_size.x - 3),
		rng.randi_range(2, chunk_size.y - 3)
	)
	tilemap.set_cell(0, pos, tile_id)