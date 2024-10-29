extends Node

const DIRT: int = 0

var rng = RandomNumberGenerator.new()


func generate_world(seed: int) -> void:
	rng.seed = seed
	
	generate_debug_ground()


func generate_debug_ground() -> void:
	for i in range(40, 45):
		for v in range(0, 80):
			Tile.create(DIRT, Vector2(v, i))
