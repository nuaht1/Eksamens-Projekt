extends Node2D

@export var SlimeScene: PackedScene = preload("res://acid_slime.tscn")

func _ready() -> void:
	randomize()
	# Assumes you added a Timer named "SpawnTimer" as a child, autostart=true, one_shot=false, wait_time=5
	var timer = $SpawnTimer
	if not timer.is_connected("timeout", Callable(self, "_on_SpawnTimer_timeout")):
		timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))

func _on_SpawnTimer_timeout() -> void:
	var slime = SlimeScene.instantiate()
	add_child(slime)
	
	# draw above the TileMap (default Z = 0)
	slime.z_index = 1
	var sprite = slime.get_node("AnimatedSprite2D")
	sprite.z_index = 1
	sprite.play("slime animation")
	
	# pick a random position in the visible viewport
	var r = get_viewport().get_visible_rect()
	slime.global_position = Vector2(
		r.position.x + randf_range(0.0, r.size.x),
		r.position.y + randf_range(0.0, r.size.y)
	)
	
	print("Spawning slime at ", slime.global_position)
