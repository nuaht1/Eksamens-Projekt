extends Node2D

@export var PlayerScene: PackedScene = preload("res://player.tscn")

func _ready() -> void:
	randomize()
	_spawn_player()

func _spawn_player() -> void:
	var player = PlayerScene.instantiate()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position
