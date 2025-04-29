extends CanvasLayer

@onready var window_dialog = $Window
@onready var craft_area    = window_dialog.get_node("TabContainer/CraftTab/CraftArea")
@onready var validate_btn  = window_dialog.get_node("TabContainer/CraftTab/Button")
@onready var spells_tab    = window_dialog.get_node("TabContainer/SpellsTab")

var learned_spells: Array[String] = []

func _ready() -> void:
	# Hide the entire UI at startup
	hide_ui()

	# Wire up the validate button and the spells tab
	validate_btn.pressed.connect(Callable(self, "_on_validate_pressed"))
	spells_tab.spell_selected.connect(Callable(self, "_on_equip_spell"))

func show_ui() -> void:
	visible = true
	window_dialog.show()


func hide_ui() -> void:
	visible = false
	window_dialog.hide()

func _on_validate_pressed() -> void:
	var angle: float = craft_area.get_molecule_angle()
	if angle < 0.0:
		return show_message("You need exactly 1 O and 2 H atoms.")

	if abs(angle - 104.5) <= 15.0:
		show_message("Water spell learned!")
		learned_spells.append("Water")
		spells_tab.update_spells(learned_spells)
		craft_area.clear_atoms()
		hide_ui()
	else:
		show_message("Angle must be ~104° (got %.1f°)" % angle)

func _on_equip_spell(spell: String) -> void:
	print("Equipped:", spell)
	# TODO: store it on the player or in a global

func show_message(text: String) -> void:
	var dlg := AcceptDialog.new()
	add_child(dlg)
	dlg.dialog_text = text
	dlg.popup_centered_minsize()
