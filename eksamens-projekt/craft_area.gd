# CraftArea.gd
extends ColorRect

@onready var HydrogenScene: PackedScene = preload("res://Atom(Hydrogen).tscn")
@onready var OxygenScene:   PackedScene = preload("res://Atom(Oxygen).tscn")

var atoms := []  # holds { element:String, node:Control }

func can_drop_data(position: Vector2, data) -> bool:
	# accept only "H" or "O"
	return data in ["H", "O"]

func drop_data(position: Vector2, data) -> void:
	var icon: Control
	if data == "H":
		icon = HydrogenScene.instantiate()
	else:
		icon = OxygenScene.instantiate()

	add_child(icon)
	icon.position = position
	icon.element = data
	icon.text = data

	atoms.append({ "element": data, "node": icon })

func get_molecule_angle() -> float:
	# find the oxygen entry
	var oxy_entry = null
	for entry in atoms:
		if entry.element == "O":
			oxy_entry = entry
			break
	# collect hydrogen entries
	var hyd_entries := []
	for entry in atoms:
		if entry.element == "H":
			hyd_entries.append(entry)

	if oxy_entry == null or hyd_entries.size() != 2:
		return -1.0

	var o_pos = oxy_entry.node.position
	var v1 = (hyd_entries[0].node.position - o_pos).normalized()
	var v2 = (hyd_entries[1].node.position - o_pos).normalized()
	return rad_to_deg(acos(v1.dot(v2)))

func clear_atoms() -> void:
	for entry in atoms:
		entry.node.queue_free()
	atoms.clear()
