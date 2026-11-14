extends Area2D

@export var padding: float = 5.0

@onready var player: Node2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../Sprite"


func _process(_delta: float) -> void:
	var frame_size := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_size()
	var player_radius := maxf(frame_size.x * sprite.global_scale.x, frame_size.y * sprite.global_scale.y) / 2.0

	var offset := player.global_position.direction_to(get_global_mouse_position()) * (player_radius + padding)
	global_position = player.global_position + offset
	rotation = offset.angle() + PI / 2
