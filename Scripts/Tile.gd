@tool
class_name Tile
extends StaticBody2D

const TILE = preload("res://Scenes/Tile.tscn")
const TILE_SIZE: int = 16


@export var data: EvergreenTileData:
	set(value):
		data = value
		
		if is_inside_tree():
			conform_to_data()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(data, "This tile does not have a TileData attached.")
	
	conform_to_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


static func create(data: EvergreenTileData, coords: Vector2) -> Tile:
	var tile = TILE.instantiate()
	tile.data = data
	tile.position = (coords + Vector2(0.5, 0.5)) * TILE_SIZE
	Game.tiles_root.add_child(tile)
	return tile


func conform_to_data() -> void:
	if not data:
		%Sprite2D.texture = null
		return
	
	%Sprite2D.texture = data.texture
