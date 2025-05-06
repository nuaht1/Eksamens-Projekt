extends PanelContainer

# 1) Preload our scenes
const AtomSlotScene = preload("res://AtomSlot.tscn")
const WaterStructure = preload("res://StructuralFormula.tscn")

# 2) Cache the nodes
@onready var spawn_h_button = $VBoxContainer/HBoxContainer/SpawnButtonH
@onready var spawn_o_button = $VBoxContainer/HBoxContainer/SpawnButtonO
@onready var craft_button   = $VBoxContainer/CraftButton
@onready var inv_panel      = $VBoxContainer/InventoryPanel
@onready var craft_panel    = $VBoxContainer/CraftingPanel
@onready var result_panel   = $VBoxContainer/ResultPanel
@onready var sucess_label = $VBoxContainer/SucessLabel
@onready var close_button = $CloseButton


func _ready():
	print("▶ CraftingMenu _ready() called")
	print("spawn_h_button =", spawn_h_button)
	print("spawn_o_button =", spawn_o_button)
	print("inv_panel       =", inv_panel)
	print("craft_panel     =", craft_panel)

	# Connect signals
	spawn_h_button.pressed.connect(_on_spawn_h)
	spawn_o_button.pressed.connect(_on_spawn_o)
	craft_button.pressed.connect(_on_craft_pressed)
	close_button.pressed.connect(_on_close_pressed)

# 3) Spawn handlers
func _on_spawn_h():
	_spawn_atom("H")

func _on_spawn_o():
	_spawn_atom("O")

# 4) Atom creation
func _spawn_atom(atom_name: String) -> void:
	# 1) Try filling the empty crafting slots first
	for slot in craft_panel.get_children():
		if slot.atom_name == "":
			slot.set_atom(atom_name)
			return

	# 2) If all crafting slots are full, send it to inventory
	var new_slot = AtomSlotScene.instantiate()
	new_slot.set_atom(atom_name)
	inv_panel.add_child(new_slot)



# 5) Craft logic
func _on_craft_pressed():
	print("▶ Craft pressed, checking slots…")
	var counts = {"H": 0, "O": 0}
	for slot in craft_panel.get_children():
		if slot.atom_name != "":
			counts[slot.atom_name] += 1

	if counts["H"] == 2 and counts["O"] == 1:
		print("✅ Recipe correct!")
		# clear the crafting slots
		sucess_label.text = "💧 Water spell crafted"
		for slot in craft_panel.get_children():
			slot.clear()
		# clear any previous result
		for child in result_panel.get_children():
			child.queue_free()
		# show the H–O–H structure
		result_panel.add_child(WaterStructure.instantiate())
	else:
		print("❌ Wrong recipe:", counts)
		var dlg = ConfirmationDialog.new()
		dlg.dialog_text = "You need exactly 2 H and 1 O!"
		add_child(dlg)
		dlg.popup_centered()

func _on_close_pressed() -> void:
	visible = false
	get_tree().paused = false
