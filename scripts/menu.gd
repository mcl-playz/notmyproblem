extends Control

@onready var start_button = $CenterContainer/VBoxContainer/Start
@onready var quit_button = $CenterContainer/VBoxContainer/Quit
@onready var click_sound = $ClickSound

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().quit()
