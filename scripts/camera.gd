extends Camera2D

## How much zoom the camera loses per second.
@export var zoom_out_speed: float = 0.01
## The camera stops zooming out at this zoom.
@export var min_zoom: float = 1.75


func _process(delta: float) -> void:
	zoom = Vector2.ONE * maxf(zoom.x - zoom_out_speed * delta, min_zoom)
