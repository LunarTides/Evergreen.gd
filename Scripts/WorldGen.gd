extends Node

const DIRT: int = 0

var rng = RandomNumberGenerator.new()


func generate_world(seed: int) -> void:
	rng.seed = seed
	
	generate_debug_ground()


func generate_debug_ground() -> void:
	for i in range(32, 64):
		for v in range(-256, 256):
			Tile.create(DIRT, Vector2(v, i))
