class_name Player
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0
@export var max_health: int = 3

@onready var health: int = max_health
@onready var health_label: Label = $HUD/HealthLabel


func _ready() -> void:
	_update_health_label()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "forward", "backward")

	if direction:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()


func take_damage(amount: int) -> void:
	health = maxi(health - amount, 0)
	_update_health_label()
	if health == 0:
		get_tree().reload_current_scene()


func _update_health_label() -> void:
	health_label.text = "HP: %d/%d" % [health, max_health]
