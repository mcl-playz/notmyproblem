class_name Player
extends CharacterBody2D

signal died

@export var speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0
@export var max_health: int = 3

@onready var health: int = max_health
@onready var health_bar: ProgressBar = $HUD/Health/Bar
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var damage_sound: AudioStreamPlayer = $DamageSound
@onready var footsteps_sound: AudioStreamPlayer = $FootstepsSound


func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "forward", "backward")

	if direction:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		if not footsteps_sound.playing:
			footsteps_sound.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		footsteps_sound.stop()

	move_and_slide()


func heal(amount: int) -> void:
	health = mini(health + amount, max_health)
	health_bar.value = health
	_show_popup("+%d HP" % amount)


## Shows text above the player's head that floats up and fades out.
func _show_popup(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size.x = 120.0
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color(0.9137255, 0.11764706, 0.3882353))
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 8)
	$HUD.add_child(label)
	# The HUD draws in screen space, so place the label over where the player's head is on screen.
	var head := get_global_transform_with_canvas() * Vector2(0, -10)
	label.position = head - Vector2(60, 34)

	var tween := label.create_tween().set_parallel()
	tween.tween_property(label, "position:y", label.position.y - 40.0, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(label.queue_free)


func take_damage(amount: int) -> void:
	if health == 0:
		return
	health = maxi(health - amount, 0)
	health_bar.value = health
	HitEffect.play(sprite)
	damage_sound.play()
	if health == 0:
		died.emit()
