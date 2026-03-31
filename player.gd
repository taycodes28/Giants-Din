extends CharacterBody2D

@export var speed := 120.0
@export var crouch_speed := 50.0

signal noise_emitted(position, intensity)

@export var walk_noise := 3.0
@export var crouch_noise := 0.5

func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	var current_speed = speed
	var current_noise = walk_noise

	if Input.is_action_pressed("ui_accept"):
		current_speed = crouch_speed
		current_noise = crouch_noise

	if direction != Vector2.ZERO:
		noise_emitted.emit(global_position, current_noise)

	velocity = direction.normalized() * current_speed
	move_and_slide()
	
	


func _on_treasure_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
