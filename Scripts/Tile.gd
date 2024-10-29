class_name Tile
extends Object

static func create(source_id: int, coords: Vector2i) -> void:
	Game.tiles_root.set_cell(coords, source_id, Vector2i.ZERO)
