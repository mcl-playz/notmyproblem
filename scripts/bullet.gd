extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 1

var direction: Vector2
## Deflected bullets hurt enemies instead of the player.
var deflected: bool = false
## The enemy a deflected bullet homes in on.
var target: Enemy

@onready var reflect_sound: AudioStreamPlayer2D = $ReflectSound


func _ready() -> void:
	direction = Vector2.LEFT.rotated(global_rotation)


func _physics_process(_delta: float) -> void:
	if is_instance_valid(target) and target.health > 0:
		direction = global_position.direction_to(target.global_position)
		rotation = Vector2.LEFT.angle_to(direction)
	velocity = direction * speed
	move_and_slide()


func _on_shield_entered(shield: Shield) -> void:
	# The shield is rotated so its local up points away from the player.
	var normal := Vector2.UP.rotated(shield.global_rotation)
	if not shield.is_parrying or direction.dot(normal) >= 0.0:
		return
	# Mirror off the shield; the bullet keeps this direction if no enemy is left to home in on.
	direction = direction.bounce(normal)
	reflect_sound.play()
	# The sprite points left, so face it along the new direction.
	rotation = Vector2.LEFT.angle_to(direction)
	deflected = true
	target = _nearest_enemy()
	shield.reflect_sound.play()


func _on_body_entered(body: Node2D) -> void:
	if (body is Player and not deflected) or (body is Enemy and deflected):
		body.take_damage(damage)
		queue_free()


func _nearest_enemy() -> Enemy:
	var nearest: Enemy = null
	for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health > 0 and (nearest == null or global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(nearest.global_position)):
			nearest = enemy
	return nearest
