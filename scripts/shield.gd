extends Node2D

@export var padding: float = 45.0

@onready var player = get_parent()
@onready var sprite = $"../Sprite"

func _process(delta):
	var direction = get_global_mouse_position() - player.global_position

	var frame_size = sprite.sprite_frames.get_frame_texture(
		sprite.animation,
		sprite.frame
	).get_size()

	var player_radius = max(
		frame_size.x * sprite.global_scale.x,
		frame_size.y * sprite.global_scale.y
	) / 2.0

	var max_radius = player_radius + padding

	direction = direction.normalized() * max_radius
	global_position = player.global_position + direction

	rotation = direction.angle() + deg_to_rad(90)
