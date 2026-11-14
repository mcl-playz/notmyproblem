extends CanvasLayer

@onready var death_sound: AudioStreamPlayer = $DeathSound
@onready var click_sound: AudioStreamPlayer = $ClickSound


func _ready() -> void:
	hide()
	$Center/Box/Retry.pressed.connect(_on_retry_pressed)
	$Center/Box/MainMenu.pressed.connect(_on_main_menu_pressed)


func open() -> void:
	show()
	get_tree().paused = true
	death_sound.play()


func _on_retry_pressed() -> void:
	await _click()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	await _click()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _click() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().paused = false
