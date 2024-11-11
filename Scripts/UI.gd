extends Control


const ITEM_FRAME := preload("res://Scenes/UI/ItemFrame.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.instance.inventory_item_added.connect(_on_player_inventory_item_added)
	Player.instance.inventory_item_removed.connect(_on_player_inventory_item_removed)
	Player.instance.hotbar_slot_changed.connect(_on_player_hotbar_slot_changed)
	
	for i in 9:
		var item_frame: Control = ITEM_FRAME.instantiate()
		item_frame.get_node(^"%Item").texture = null
		item_frame.get_node(^"%Count").text = "0"
		item_frame.get_node(^"%Count").hide()
		
		%Inventory.add_child(item_frame)
		item_frame.name = "%s" % i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%FPSLabel.text = "FPS: %d" % Performance.get_monitor(Performance.TIME_FPS)


func _on_player_inventory_item_added(item: Item, amount: int, slot: int) -> void:
	var frame: TextureRect = %Inventory.get_node("%s" % slot)
	
	frame.get_node(^"%Item").texture = item.data.texture
	
	frame.get_node(^"%Count").show()
	frame.get_node(^"%Count").text = "%s" % (int(frame.get_node(^"%Count").text) + amount)


func _on_player_inventory_item_removed(item_data: ItemData, amount: int, slot: int) -> void:
	var frame: TextureRect = %Inventory.get_node("%s" % slot)
	
	var new_count = int(frame.get_node(^"%Count").text) - amount
	if new_count <= 0:
		frame.get_node(^"%Count").text = "0"
		frame.get_node(^"%Count").hide()
		
		frame.get_node(^"%Item").texture = null
		return
	
	frame.get_node(^"%Count").text = "%s" % new_count


func _on_player_hotbar_slot_changed(old_slot: int, new_slot: int) -> void:
	var old_frame: TextureRect = %Inventory.get_node("%s" % old_slot)
	var new_frame: TextureRect = %Inventory.get_node("%s" % new_slot)
	
	new_frame.self_modulate = Color.hex(0xff45c0ff)
	old_frame.self_modulate = Color.hex(0xffffffff)
