class_name Item
extends CharacterBody2D


const ATTRACT_SPEED := 7500.0

@export var data: ItemData:
	set(value):
		data = value
		
		conform_to_data()

var terminal_velocity := 400.0
var deceleration_speed := 2.0
var attracting: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	conform_to_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if attracting:
		velocity = (Player.instance.global_position - global_position).normalized() * ATTRACT_SPEED * delta
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
		velocity.y = minf(velocity.y, terminal_velocity)

	move_and_slide()


func conform_to_data() -> void:
	%Sprite2D.texture = data.texture


func _on_attract_area_body_entered(body: Node2D) -> void:
	attracting = true
	collision_mask = 0


func _on_attract_area_body_exited(body: Node2D) -> void:
	attracting = false
	collision_mask = 1


func _on_pickup_area_body_entered(body: Node2D) -> void:
	Player.instance.add_to_inventory(self, 1)
	queue_free()
