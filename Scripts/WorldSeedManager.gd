extends Node

var world_seed: int = 0

func generate_random_seed() -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi()

func set_seed_from_input(input: String):
	if input.is_valid_int():
		world_seed = int(input)
	else:
		world_seed = hash(input)

func get_seed() -> int:
	return world_seed
