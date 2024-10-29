class_name Tile
extends Object


const ITEM = preload("res://Scenes/Item.tscn")


static func create(source_id: int, coords: Vector2i) -> void:
	Game.tiles_root.set_cell(coords, source_id, Vector2i.ZERO)


static func dig(coords: Vector2i) -> void:
	var tile_data := Game.tiles_root.get_cell_tile_data(coords)
	Game.tiles_root.erase_cell(coords)
	
	if not tile_data:
		return
	
	var item_to_drop: ItemData = tile_data.get_custom_data("ItemToDrop")
	if item_to_drop:
		var item: Item = ITEM.instantiate()
		item.data = item_to_drop
		item.global_position = coords * 16
		Game.world.add_child(item)
