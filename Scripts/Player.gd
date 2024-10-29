class_name Player
extends CharacterBody2D


var acceleration_speed := 10.0
var deceleration_speed := 30.0
var max_speed := 200.0
var jump_velocity := 400.0
var terminal_velocity := 400.0


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
