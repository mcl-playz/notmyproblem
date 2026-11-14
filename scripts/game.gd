extends Node2D

var score: int = 0

@onready var score_label: Label = $HUD/Score
@onready var death_screen: CanvasLayer = $DeathScreen


func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	for child in get_children():
		_on_child_entered_tree(child)
	$Player.died.connect(func() -> void: death_screen.open(score))


func _on_child_entered_tree(node: Node) -> void:
	if node is Enemy:
		node.died.connect(_on_enemy_died)


func _on_enemy_died() -> void:
	score += 1
	score_label.text = "Score: %d" % score
