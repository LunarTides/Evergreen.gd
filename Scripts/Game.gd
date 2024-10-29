extends Node


var world: Node2D:
	get:
		return get_tree().get_first_node_in_group(&"World")

var tiles_root: TileMapLayer:
	get:
		return world.get_node(^"Tiles")

var is_mouse_holding := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var seed = randi()
	
	WorldGen.generate_world(seed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_mouse_holding:
		Tile.dig(mouse_to_world_coords())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(&"dig"):
		is_mouse_holding = event.is_pressed()
	
	if event.is_released():
		return
	
	var key := event.as_text()
	
	if key == "Escape":
		get_tree().quit()
	
	if OS.is_debug_build():
		match key:
			"F1": print_debug("Debug 1")
			"F2": print_debug("Debug 2")
			"F3": print_debug("Debug 3")


func mouse_to_world_position() -> Vector2:
	var camera: Camera2D = Player.instance.get_node(^"Camera2D")
	return camera.get_global_mouse_position()


func mouse_to_world_coords() -> Vector2i:
	var mouse_position = mouse_to_world_position()
	return tiles_root.local_to_map(mouse_position)
