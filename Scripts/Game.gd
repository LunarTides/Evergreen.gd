extends Node


var world: Node2D:
	get:
		return get_tree().get_first_node_in_group(&"World")

var tiles_root: TileMapLayer:
	get:
		return world.get_node(^"Tiles")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var seed = randi()
	
	WorldGen.generate_world(seed)



func _unhandled_input(event: InputEvent) -> void:
	if event.is_released():
		return
	
	var key := event.as_text()
	
	if key == "Escape":
		get_tree().quit()
	
	if OS.is_debug_build():
		match key:
			"F1":
				# TODO: Add a debug menu where you can give yourself any item.
				const DEBUG_PICKAXE = preload("res://Resources/Items/DebugPickaxe.tres")
				var pickaxe = Item.create(DEBUG_PICKAXE)
				
				Player.instance.add_to_inventory(pickaxe, 1)
			"F2": print_debug("Debug 2")
			"F3": print_debug("Debug 3")


func mouse_to_world_position() -> Vector2:
	var camera: Camera2D = Player.instance.get_node(^"Camera2D")
	return camera.get_global_mouse_position()


func mouse_to_world_coords() -> Vector2i:
	var mouse_position = mouse_to_world_position()
	return tiles_root.local_to_map(mouse_position)
