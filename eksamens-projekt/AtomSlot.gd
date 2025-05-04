# res://scripts/AtomSlot.gd
extends Control
class_name AtomSlot

# What atom this slot holds (empty = nothing)
var atom_name: String = ""

func set_atom(name: String) -> void:
	atom_name = name
	$Label.text = name
	show()

func clear() -> void:
	atom_name = ""
	$Label.text = ""
	show()

# Called automatically when the user drags this Control
func _get_drag_data(position: Vector2):
	if atom_name == "":
		return null
	# package up our atom name AND a reference to ourselves
	var drag_data = {
		"atom": atom_name,
		"source": self
	}
	# build a simple preview
	var preview = Label.new()
	preview.text = atom_name
	preview.modulate.a = 0.7
	set_drag_preview(preview)
	return drag_data

# Can we drop data here?
func _can_drop_data(position: Vector2, data: Variant) -> bool:
	# accept only if it's a dict with “atom”, and we're currently empty
	return data is Dictionary and data.has("atom") and atom_name == ""

# Handle the actual drop
func _drop_data(position: Vector2, data: Variant) -> void:
	# take on the incoming atom
	set_atom(data["atom"])
	# clear out the source slot
	var src = data.get("source", null)
	if src and src is AtomSlot and src != self:
		src.clear()
