extends Node

const BIOMES = {
	"forest": 0,
	"desert": 1,
	"snow": 2,
	"swamp": 3,
	"mountain": 4,
	"ocean": 5
}

var noise := FastNoiseLite.new()

func configure(seed_value: int):
	noise.seed = seed_value
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5
	noise.frequency = 1.0 / 64.0  # equivalent to period = 64.0

func get_biome_at(global_x: float, global_y: float) -> String:
	var value = noise.get_noise_2d(global_x / 32.0, global_y / 32.0)
	if value < -0.4:
		return "ocean"
	elif value < -0.1:
		return "swamp"
	elif value < 0.2:
		return "forest"
	elif value < 0.4:
		return "desert"
	elif value < 0.6:
		return "mountain"
	else:
		return "snow"
