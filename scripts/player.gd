extends CharacterBody2D

const SPEED = 500.0
const ACCELERATION = 10000.0;
const FRICTION = 1000.0

func _physics_process(delta):
	var direction = Input.get_vector(
		"left",
		"right",
		"forward",
        "backward"
	)

	if direction:
		#velocity = direction * SPEED
		velocity = velocity.move_toward(
			direction * SPEED,
			ACCELERATION * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			FRICTION * delta
		)

	move_and_slide()
