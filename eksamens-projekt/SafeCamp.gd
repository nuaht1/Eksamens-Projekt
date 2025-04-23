extends Node2D

@export var PlayerScene: PackedScene = preload("res://player.tscn")
@export var CombatScene: String = "res://node_2d.tscn"

var player: Node2D
var inside_portal: bool = false

func _ready() -> void:
	randomize()
	_spawn_player()
	var portal = $Portal
	if not portal.is_connected("body_entered", Callable(self, "_on_Portal_body_entered")):
		portal.connect("body_entered", Callable(self, "_on_Portal_body_entered"))
	if not portal.is_connected("body_exited", Callable(self, "_on_Portal_body_exited")):
		portal.connect("body_exited", Callable(self, "_on_Portal_body_exited"))

func _spawn_player() -> void:
	player = PlayerScene.instantiate()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position

func _on_Portal_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		inside_portal = true
		print("Entered portal area. Press F to go to combat.")

func _on_Portal_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		inside_portal = false
		print("Left portal area.")

func _process(_delta: float) -> void:
	if inside_portal and Input.is_action_just_pressed("enter_portal"):
		get_tree().change_scene_to_file(CombatScene)
