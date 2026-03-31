extends Label

@export var typing_speed := 0.15

func _ready():
	var full_text = "SSSSSHHHHHHHHH ! !"
	text = ""
	for character in full_text:
		text += character
		await get_tree().create_timer(typing_speed).timeout
