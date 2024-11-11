class_name Player
extends CharacterBody2D


signal inventory_item_added(item: Item, amount: int, slot: int)
signal hotbar_slot_changed(old_slot: int, new_slot: int)


var acceleration_speed := 10.0
var deceleration_speed := 30.0
var max_speed := 200.0
var jump_velocity := 400.0
var terminal_velocity := 400.0

var inventory: Dictionary
var hotbar_slot_selected: int:
	set(value):
		var old = hotbar_slot_selected
		hotbar_slot_selected = value
		
		if hotbar_slot_selected != old:
			hotbar_slot_changed.emit(old, value)
var selected_item_data: ItemData:
	get:
		if inventory.size() <= hotbar_slot_selected:
			return null
		
		return inventory[hotbar_slot_selected].item_data
var is_mouse_holding := false

static var instance:
	get:
		var tree: SceneTree = Engine.get_main_loop().root.get_tree()
		return tree.get_first_node_in_group(&"Player")


func _process(delta: float) -> void:
	if is_mouse_holding:
		if selected_item_data && selected_item_data.type == ItemData.Type.Tool:
			Tile.dig(Game.mouse_to_world_coords())


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = -jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(&"move_left", &"move_right")
	if direction:
		# Allow instant turning.
		if sign(velocity.x) != sign(direction):
			velocity.x = 0
		
		velocity.x += direction * acceleration_speed
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
	
	velocity.x = clampf(velocity.x, -max_speed, max_speed)
	velocity.y = minf(velocity.y, terminal_velocity)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(&"dig"):
		is_mouse_holding = event.is_pressed()
	
	if event.is_released():
		return
	
	var key := event.as_text()
	
	if key.is_valid_int():
		hotbar_slot_selected = int(key) - 1


func add_to_inventory(item: Item, amount: int) -> int:
	# Check if the inventory already has this item.
	for i in inventory.keys():
		var stack: Dictionary = inventory[i]
		var new_item: ItemData = stack.item_data
		
		if item.data == new_item && stack.count < new_item.max_stack:
			stack.count += amount
			inventory_item_added.emit(item, amount, i)
			return i
	
	# The inventory doesn't have the item. Add it to a new slot.
	# TODO: Limit this to however many inventory slots.
	var slot = inventory.keys().size()
	if inventory.size() <= slot:
		inventory[slot] = {}
	
	for i in amount:
		inventory[slot].item_data = item.data
		inventory[slot].count = amount
	
	inventory_item_added.emit(item, amount, slot)
	return slot
