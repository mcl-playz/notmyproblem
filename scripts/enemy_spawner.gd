extends Timer

@export var enemy_scene: PackedScene
@export var max_enemies: int = 5
## How far from the player enemies appear, just outside the camera view.
@export var spawn_distance: float = 100.0


func _ready() -> void:
	timeout.connect(_spawn)


func _spawn() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null or get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return

	var enemy: Node2D = enemy_scene.instantiate()
	enemy.global_position = player.global_position + Vector2.RIGHT.rotated(randf() * TAU) * spawn_distance
	get_parent().add_child(enemy)
