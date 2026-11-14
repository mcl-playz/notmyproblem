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

	var camera := get_viewport().get_camera_2d()
	var half_view := get_viewport().get_visible_rect().size / camera.zoom / 2.0 + Vector2.ONE * spawn_margin
	var arena = get_tree().get_first_node_in_group("arena")
	# Pick a random direction and go just past the edge of the screen that way. Try again
	# until the point is on the island rather than in the water; if none is, skip this spawn.
	for attempt in 16:
		var direction := Vector2.RIGHT.rotated(randf() * TAU)
		var distance := minf(half_view.x / absf(direction.x), half_view.y / absf(direction.y))
		var spawn_position := camera.get_screen_center_position() + direction * distance
		if arena == null or arena.clamp_inside(spawn_position, 10.0) == spawn_position:
			var enemy: Node2D = enemy_scene.instantiate()
			enemy.global_position = spawn_position
			get_parent().add_child(enemy)
			return
