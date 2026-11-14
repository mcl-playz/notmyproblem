class_name Player
extends CharacterBody2D

signal died

@export var speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0
@export var max_health: int = 3

@onready var health: int = max_health
@onready var health_bar: ProgressBar = $HUD/Health/Bar
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var damage_sound: AudioStreamPlayer = $DamageSound
@onready var footsteps_sound: AudioStreamPlayer = $FootstepsSound


func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "forward", "backward")

	if direction:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		if not footsteps_sound.playing:
			footsteps_sound.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		footsteps_sound.stop()

	move_and_slide()


func take_damage(amount: int) -> void:
	if health == 0:
		return
	health = maxi(health - amount, 0)
	health_bar.value = health
	HitEffect.play(sprite)
	damage_sound.play()
	if health == 0:
		died.emit()
