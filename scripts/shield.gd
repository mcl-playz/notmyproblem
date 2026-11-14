class_name Shield
extends Area2D

@export var padding: float = 5.0
## How long the shield deflects bullets after a click, in seconds.
@export var parry_window: float = 0.3
## Time after a click before the next click can parry, in seconds.
@export var parry_cooldown: float = 0.4

var parry_time_left: float = 0.0
var cooldown_left: float = 0.0
var is_parrying: bool:
	get:
		return parry_time_left > 0.0

@onready var player: Node2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../Sprite"
@onready var shield_sprite: Sprite2D = $Sprite
@onready var reflect_sound: AudioStreamPlayer = $ReflectSound


func _process(delta: float) -> void:
	var frame_size := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_size()
	var player_radius := maxf(frame_size.x * sprite.global_scale.x, frame_size.y * sprite.global_scale.y) / 2.0

	var offset := player.global_position.direction_to(get_global_mouse_position()) * (player_radius + padding)
	global_position = player.global_position + offset
	rotation = offset.angle() + PI / 2

	parry_time_left = maxf(parry_time_left - delta, 0.0)
	cooldown_left = maxf(cooldown_left - delta, 0.0)
	if Input.is_action_just_pressed("parry") and cooldown_left == 0.0:
		parry_time_left = parry_window
		cooldown_left = parry_cooldown

	if is_parrying:
		shield_sprite.modulate = Color(1.8, 1.8, 1.8)
	elif cooldown_left > 0.0:
		shield_sprite.modulate = Color(1, 1, 1, 0.4)
	else:
		shield_sprite.modulate = Color.WHITE
