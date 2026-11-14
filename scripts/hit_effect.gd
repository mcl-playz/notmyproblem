class_name HitEffect

## Flashes the sprite red and tilts it, then eases both back.
static func play(sprite: Node2D, duration: float = 0.3) -> Tween:
	sprite.modulate = Color(2.0, 0.3, 0.3)
	sprite.rotation = deg_to_rad(20.0) * (1.0 if randf() < 0.5 else -1.0)
	var tween := sprite.create_tween().set_parallel()
	tween.tween_property(sprite, "modulate", Color.WHITE, duration)
	tween.tween_property(sprite, "rotation", 0.0, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	return tween
