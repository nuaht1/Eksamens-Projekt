# SpellCrafting.gd
extends CanvasLayer

@export var AtomScene: PackedScene = preload("res://Atom.tscn")

@onready var craft_area   := $"CraftArea"
@onready var panel        := $"PanelContainer"
@onready var btn_h        := panel.get_node("HBoxContainer/ButtonHydrogen")
@onready var btn_o        := panel.get_node("HBoxContainer/ButtonOxygen")
@onready var btn_validate := panel.get_node("ButtonValidate")

func _ready() -> void:
	# start hidden
	panel.visible = false

	# wire up spawning & validation
	btn_h.pressed.connect(_spawn_h)
	btn_o.pressed.connect(_spawn_o)
	btn_validate.pressed.connect(_validate_structure)

func show_ui() -> void:
	panel.visible = true

func hide_ui() -> void:
	panel.visible = false

func _spawn_h() -> void:
	var a = AtomScene.instantiate()
	a.element = "H"
	craft_area.add_child(a)
	a.global_position = craft_area.global_position

func _spawn_o() -> void:
	var a = AtomScene.instantiate()
	a.element = "O"
	craft_area.add_child(a)
	a.global_position = craft_area.global_position

func _validate_structure() -> void:
	# …your existing angle‐check code…
	# when done:
	hide_ui()
