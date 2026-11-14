extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 1

var direction: Vector2
## Deflected bullets hurt enemies instead of the player.
var deflected: bool = false


func _ready() -> void:
	direction = Vector2.LEFT.rotated(global_rotation)


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_shield_entered(shield: Shield) -> void:
	# The shield is rotated so its local up points away from the player.
	var normal := Vector2.UP.rotated(shield.global_rotation)
	if not shield.is_parrying or direction.dot(normal) >= 0.0:
		return
	direction = direction.bounce(normal)
	# The sprite points left, so face it along the new direction.
	rotation = Vector2.LEFT.angle_to(direction)
	deflected = true


func _on_body_entered(body: Node2D) -> void:
	if (body is Player and not deflected) or (body is Enemy and deflected):
		body.take_damage(damage)
		queue_free()
