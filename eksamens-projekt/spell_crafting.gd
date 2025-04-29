# SpellCrafting.gd
extends CanvasLayer

@export var AtomScene: PackedScene = preload("res://Atom.tscn")

@onready var craft_area   := $CraftArea                        # your Node2D
@onready var panel        := $PanelContainer                   # your UI
@onready var btn_h        := panel.get_node("HBoxContainer/ButtonHydrogen")
@onready var btn_o        := panel.get_node("HBoxContainer/ButtonOxygen")
@onready var btn_validate := panel.get_node("ButtonValidate")

func _ready() -> void:
	# start hidden
	panel.visible = false

	# wire up the buttons
	btn_h.pressed.connect(_spawn_h)
	btn_o.pressed.connect(_spawn_o)
	btn_validate.pressed.connect(_validate_structure)

func show_ui() -> void:
	# clear old atoms and show
	for c in craft_area.get_children():
		c.queue_free()
	panel.visible = true

func hide_ui() -> void:
	panel.visible = false

func _spawn_h() -> void:
	var a = AtomScene.instantiate()
	# tag and label it
	a.element = "H"
	a.text = "H"
	craft_area.add_child(a)
	a.global_position = craft_area.global_position

func _spawn_o() -> void:
	var a = AtomScene.instantiate()
	a.element = "O"
	a.text = "O"
	craft_area.add_child(a)
	a.global_position = craft_area.global_position

func _validate_structure() -> void:
	var hyds := []
	var oxy  = null
	for child in craft_area.get_children():
		if child is Label:
			if child.element == "H":
				hyds.append(child)
			elif child.element == "O":
				oxy = child

	if oxy == null or hyds.size() != 2:
		print("❌ You need exactly 1 O and 2 H.")
		return

	var o_pos = oxy.global_position
	var v1    = (hyds[0].global_position - o_pos).normalized()
	var v2    = (hyds[1].global_position - o_pos).normalized()
	var angle = rad_to_deg(acos(v1.dot(v2)))

	print("H–O–H angle:", angle)
	if abs(angle - 104.5) <= 15.0:
		print("✅ Water Spell crafted!")
		hide_ui()
	else:
		print("❌ Angle off by", abs(angle - 104.5), "degrees.")
