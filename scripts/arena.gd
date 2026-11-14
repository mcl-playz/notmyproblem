@tool
extends Node2D

## Size of the island. Everything outside it is water the player can't walk into.
@export var size: Vector2 = Vector2(1200, 1200):
	set(value):
		size = value
		if is_node_ready():
			_build()


func _ready() -> void:
	_build()


func _build() -> void:
	var half := size / 2.0
	var corners := PackedVector2Array([-half, Vector2(half.x, -half.y), half, Vector2(-half.x, half.y)])
	$Ground.polygon = corners
	$Shore.points = corners
	$Walls/CollisionPolygon2D.polygon = corners


## Moves a point onto the island, at least `margin` from the water.
func clamp_inside(point: Vector2, margin: float) -> Vector2:
	var half := size / 2.0 - Vector2.ONE * margin
	return point.clamp(global_position - half, global_position + half)
