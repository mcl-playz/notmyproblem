class_name Enemy
extends CharacterBody2D

@export var speed: float = 25.0
@export var bullet_scene: PackedScene
@export var shoot_interval: float = 2.0
@export var stopping_distance: float = 40.0
@export var max_health: int = 1

var player: Node2D
var shoot_timer: float = 0.0

@onready var health: int = max_health


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	var direction := global_position.direction_to(player.global_position)

	if global_position.distance_to(player.global_position) > stopping_distance:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		shoot(-direction)

func shoot(direction: Vector2) -> void:
	if not bullet_scene:
		return

	var bullet: Node2D = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.global_rotation = direction.angle()
	get_tree().current_scene.add_child(bullet)


func take_damage(amount: int) -> void:
	health = maxi(health - amount, 0)
	if health == 0:
		queue_free()
