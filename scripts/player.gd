class_name Player
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0
@export var max_health: int = 3

@onready var health: int = max_health
@onready var health_bar: ProgressBar = $HUD/Health/Bar
@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "forward", "backward")

	if direction:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()


func take_damage(amount: int) -> void:
	health = maxi(health - amount, 0)
	health_bar.value = health
	HitEffect.play(sprite)
	if health == 0:
		get_tree().reload_current_scene()
