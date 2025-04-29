extends VBoxContainer

signal spell_selected(spell: String)

func update_spells(spells: Array[String]) -> void:
	# Remove any old buttons
	for child in get_children():
		child.queue_free()

	# Add a toggle button for each spell
	for spell in spells:
		var btn := Button.new()
		btn.text = spell
		btn.toggle_mode = true

		# Bind the spell name to the callback
		var cb := Callable(self, "_on_spell_button_pressed").bind(spell)
		btn.pressed.connect(cb)

		add_child(btn)

func _on_spell_button_pressed(spell: String) -> void:
	emit_signal("spell_selected", spell)
