extends Node2D

var has_treasure := false

func _ready():
	$ExitDoor.body_entered.connect(_on_exit_reached)

func _on_exit_reached(body):
	if body.is_in_group("player") and has_treasure:
		get_tree().change_scene_to_file("res://win_screen.tscn")

func _on_treasure_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		has_treasure = true
		$Treasure.hide()
