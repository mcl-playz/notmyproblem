extends CharacterBody2D

## How far the shield may move from where the bullet touched it and still deflect it during coyote time.
const COYOTE_REACH := 8.0

@export var speed: float = 100.0
@export var damage: int = 1

var direction: Vector2
## Deflected bullets hurt enemies instead of the player.
var deflected: bool = false
## The enemy a deflected bullet homes in on.
var target: Enemy

## Set when the bullet reaches the shield before the click: a click within the
## shield's coyote time still deflects it from where it touched the shield.
var coyote_shield: Shield
var coyote_left: float = 0.0
var coyote_position: Vector2
## The player this bullet reached during coyote time. It waits there, and only
## damages them if the coyote time runs out without a click.
var pending_hit: Player

@onready var reflect_sound: AudioStreamPlayer2D = $ReflectSound


func _ready() -> void:
	direction = Vector2.LEFT.rotated(global_rotation)


func _physics_process(delta: float) -> void:
	if coyote_left > 0.0:
		coyote_left -= delta
		if _can_deflect(coyote_shield) and coyote_shield.global_position.distance_to(coyote_position) <= COYOTE_REACH:
			global_position = coyote_position
			_deflect(coyote_shield)
		elif coyote_left <= 0.0 and pending_hit:
			_hit(pending_hit)
			return
	if pending_hit:
		return
	if is_instance_valid(target) and target.health > 0:
		direction = global_position.direction_to(target.global_position)
		rotation = Vector2.LEFT.angle_to(direction)
	velocity = direction * speed
	move_and_slide()


func _on_shield_entered(shield: Shield) -> void:
	if _can_deflect(shield):
		_deflect(shield)
	elif not deflected:
		coyote_shield = shield
		coyote_left = shield.coyote_time
		coyote_position = global_position


func _can_deflect(shield: Shield) -> bool:
	return shield.is_parrying and direction.dot(_shield_normal(shield)) < 0.0


## The shield is rotated so its local up points away from the player.
func _shield_normal(shield: Shield) -> Vector2:
	return Vector2.UP.rotated(shield.global_rotation)


func _deflect(shield: Shield) -> void:
	var normal := _shield_normal(shield)
	# Mirror off the shield; the bullet keeps this direction if no enemy is left to home in on.
	direction = direction.bounce(normal)
	reflect_sound.play()
	# The sprite points left, so face it along the new direction.
	rotation = Vector2.LEFT.angle_to(direction)
	deflected = true
	target = _nearest_enemy()
	shield.reflect_sound.play()
	coyote_left = 0.0
	pending_hit = null


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not deflected:
		if coyote_left > 0.0:
			pending_hit = body
		else:
			_hit(body)
	elif body is Enemy and deflected:
		_hit(body)


func _hit(body: Node2D) -> void:
	body.take_damage(damage)
	queue_free()


func _nearest_enemy() -> Enemy:
	var nearest: Enemy = null
	for enemy: Enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health > 0 and (nearest == null or global_position.distance_squared_to(enemy.global_position) < global_position.distance_squared_to(nearest.global_position)):
			nearest = enemy
	return nearest
