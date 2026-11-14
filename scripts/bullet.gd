extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 1

var direction: Vector2


func _ready() -> void:
	direction = Vector2.LEFT.rotated(global_rotation)


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_shield_entered(shield: Shield) -> void:
	if not shield.is_parrying:
		return
	direction = direction.bounce(shield.global_position.direction_to(global_position))
	rotation = direction.angle()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
		queue_free()
