extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "forward", "backward")

	if direction:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
