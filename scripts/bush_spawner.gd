extends Timer

@export var bush_scene: PackedScene
## Bushes appear at least this far from the player.
@export var min_distance: float = 25.0


func _ready() -> void:
	timeout.connect(_spawn)


func _spawn() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	# Somewhere the player can see: inside the smaller half of the camera view.
	var view_size := get_viewport().get_visible_rect().size / get_viewport().get_camera_2d().zoom
	var max_distance := maxf(minf(view_size.x, view_size.y) / 2.0 * 0.8, min_distance)
	var spawn_position := player.global_position + Vector2.RIGHT.rotated(randf() * TAU) * randf_range(min_distance, max_distance)
	var arena = get_tree().get_first_node_in_group("arena")
	if arena:
		spawn_position = arena.clamp_inside(spawn_position, 10.0)
	var bush: Node2D = bush_scene.instantiate()
	bush.global_position = spawn_position
	get_parent().add_child(bush)
