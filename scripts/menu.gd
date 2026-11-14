extends Control

@onready var start_button = $Buttons/Start
@onready var quit_button = $Buttons/Quit
@onready var click_sound = $ClickSound

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	for button in [start_button, quit_button]:
		button.mouse_entered.connect(func(): button.modulate = Color(1.2, 1.2, 1.2))
		button.mouse_exited.connect(func(): button.modulate = Color.WHITE)

func _on_start_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().quit()
