extends CharacterBody2D

enum State { SLEEPING, STIRRING, AWAKE }
var state = State.AWAKE

@onready var sprite = $Sprite2D
@export var sleeping_texture : Texture2D
@export var awake_texture : Texture2D

@export var hearing_range := 200.0
@export var speed := 80.0

var alert_level := 0.0
var last_noise_position := Vector2.ZERO
var player

func _ready():
	player = get_node("../Player")
	if player:
		player.noise_emitted.connect(_on_noise_received)
	else:
		print("ERROR: Player not found!")

func _on_noise_received(pos, intensity):
	var distance = global_position.distance_to(pos)
	if distance <= hearing_range:
		alert_level += intensity
		last_noise_position = pos

func _physics_process(delta):
	if player == null:
		return
	match state:
		State.SLEEPING:
			sprite.texture = sleeping_texture
			if alert_level >= 10.0:
				state = State.AWAKE
			elif alert_level >= 5.0:
				state = State.STIRRING
			alert_level = max(0, alert_level - 0.5 * delta)
		State.STIRRING:
			sprite.texture = sleeping_texture
			if alert_level >= 10.0:
				state = State.AWAKE
			elif alert_level <= 0:
				state = State.SLEEPING
		State.AWAKE:
			sprite.texture = awake_texture
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			var dist = global_position.distance_to(player.global_position)
			print("dist: ", dist)
			if dist < 300:
				get_tree().change_scene_to_file("res://game_over.tscn")


func _on_detection_zone_body_entered(body: Node2D) -> void:
	print("touched: ", body.name)
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://game_over.tscn")
