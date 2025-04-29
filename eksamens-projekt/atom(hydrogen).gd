# DraggableAtom.gd
extends Button

@export var element: String  # "H" or "O"

func get_drag_data(position: Vector2) -> Variant:
	# Create a little preview label
	var preview = Label.new()
	preview.text = element
	preview.add_theme_color_override("font_color", Color.WHITE)
	set_drag_preview(preview)
	return element

func can_drop_data(position: Vector2, data: Variant) -> bool:
	# We never accept drops on the palette itself
	return false

func drop_data(position: Vector2, data: Variant) -> void:
	# No‐op here
	pass
