extends Area2D

@export var heal_amount: int = 1
## Seconds before an untouched bush disappears.
@export var lifetime: float = 20.0


func _ready() -> void:
	get_tree().create_timer(lifetime, false).timeout.connect(queue_free)


func _physics_process(_delta: float) -> void:
	# Checked every frame, so a bush the player is standing in heals them as soon as they get hurt.
	for body in get_overlapping_bodies():
		if body is Player and body.health < body.max_health:
			body.heal(heal_amount)
			queue_free()
			return
