extends Node2D

@export var PlayerScene: PackedScene = preload("res://player.tscn")
@export var CombatScene: String       = "res://node_2d.tscn"
@onready var crafting_menu = $UISpellCraft/CraftingMenu
@onready var craft_guide_label = get_node("/root/SafeCamp/UISpellCraft/CraftGuideLabel")
@onready var portal_guide_label = get_node("/root/SafeCamp/UISpellCraft/PortalGuideLabel")


# runtime state
var player: Node2D
var inside_portal: bool   = false
var inside_crafting: bool = false


func _ready() -> void:
	randomize()
	_spawn_player()

	# portal enter/exit
	var portal = $Portal
	if not portal.is_connected("body_entered", Callable(self, "_on_Portal_body_entered")):
		portal.connect("body_entered", Callable(self, "_on_Portal_body_entered"))
	if not portal.is_connected("body_exited", Callable(self, "_on_Portal_body_exited")):
		portal.connect("body_exited", Callable(self, "_on_Portal_body_exited"))

	# ----- crafting area signals -----
	var craft_area = $CraftingArea
	var entered_cb = Callable(self, "_on_CraftingArea_body_entered")
	var exited_cb  = Callable(self, "_on_CraftingArea_body_exited")

	if not craft_area.is_connected("body_entered", entered_cb):
		craft_area.connect("body_entered", entered_cb)
	if not craft_area.is_connected("body_exited",  exited_cb):
		craft_area.connect("body_exited",  exited_cb)

	crafting_menu.visible = false

func _spawn_player() -> void:
	player = PlayerScene.instantiate()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position

func _on_Portal_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		inside_portal = true
		print("Entered portal area. Press F to go to combat.")
		portal_guide_label.visible = true

func _on_Portal_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		inside_portal = false
		print("Left portal area.")
		portal_guide_label.visible = false

func _on_CraftingArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		inside_crafting = true
		print("Entered crafting area. Press C to open crafting menu.")
		craft_guide_label.visible = true

func _on_CraftingArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		inside_crafting = false
		print("Left crafting area.")
		craft_guide_label.visible = false

# Use _unhandled_input so UI buttons still work when menu is up
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("craft") and player and inside_crafting:
		crafting_menu.visible = not crafting_menu.visible
		# pause the world when crafting
		get_tree().paused = crafting_menu.visible

	if event.is_action_pressed("enter_portal") and inside_portal:
		get_tree().change_scene_to_file(CombatScene)
