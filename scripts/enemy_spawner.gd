extends Timer

@export var enemy_scene: PackedScene
## How many enemies can be alive at the start.
@export var start_max_enemies: int = 3
## The enemy limit never grows past this.
@export var enemy_cap: int = 10
## Seconds between each +1 to the enemy limit.
@export var ramp_interval: float = 15.0
## How far past the edge of the camera view enemies appear.
@export var spawn_margin: float = 20.0

var elapsed: float = 0.0
var max_enemies: int:
	get:
		return mini(start_max_enemies + int(elapsed / ramp_interval), enemy_cap)


func _ready() -> void:
	timeout.connect(_spawn)


func _process(delta: float) -> void:
	elapsed += delta


func _spawn() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null or get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return

	var view_size := get_viewport().get_visible_rect().size / get_viewport().get_camera_2d().zoom
	var distance := view_size.length() / 2.0 + spawn_margin
	var enemy: Node2D = enemy_scene.instantiate()
	enemy.global_position = player.global_position + Vector2.RIGHT.rotated(randf() * TAU) * distance
	get_parent().add_child(enemy)
