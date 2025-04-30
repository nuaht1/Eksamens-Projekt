extends Node2D

@export var PlayerScene: PackedScene = preload("res://player.tscn")
@export var CombatScene: String       = "res://node_2d.tscn"

# runtime state
var player: Node2D
var inside_portal: bool   = false
var inside_crafting: bool = false

# cache the crafting UI (CanvasLayer)  
@onready var spell_ui: Node = $SpellCrafting

func _ready() -> void:
	randomize()
	_spawn_player()

	# portal enter/exit
	var portal = $Portal
	if not portal.is_connected("body_entered", Callable(self, "_on_Portal_body_entered")):
		portal.connect("body_entered", Callable(self, "_on_Portal_body_entered"))
	if not portal.is_connected("body_exited", Callable(self, "_on_Portal_body_exited")):
		portal.connect("body_exited", Callable(self, "_on_Portal_body_exited"))

	# crafting‐area enter/exit
	var craft_area = $CraftingArea
	if not craft_area.is_connected("body_entered", Callable(self, "_on_CraftingArea_body_entered")):
		craft_area.connect("body_entered", Callable(self, "_on_CraftingArea_body_entered"))
	if not craft_area.is_connected("body_exited", Callable(self, "_on_CraftingArea_body_exited")):
		craft_area.connect("body_exited", Callable(self, "_on_CraftingArea_body_exited"))

func _spawn_player() -> void:
	player = PlayerScene.instantiate()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position

func _on_Portal_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		inside_portal = true
		print("Entered portal area. Press F to go to combat.")
		ScoreManager.reset_score()


func _on_Portal_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		inside_portal = false
		print("Left portal area.")

func _on_CraftingArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		inside_crafting = true
		print("Entered crafting area. Press C to craft spells.")

func _on_CraftingArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		inside_crafting = false
		print("Left crafting area.")

func _process(_delta: float) -> void:
	# teleport to combat on F
	if inside_portal and Input.is_action_just_pressed("enter_portal"):
		get_tree().change_scene_to_file(CombatScene)

func _input(event: InputEvent) -> void:
	if inside_crafting and event is InputEventKey and event.pressed and event.keycode == KEY_C:
		$SpellCrafting.show_ui()
