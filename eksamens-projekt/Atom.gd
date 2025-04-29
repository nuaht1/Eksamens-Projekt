# Atom.gd
extends Label

# will be set to "H" or "O" by the spawner
var element: String = ""

var dragging := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	set_process_unhandled_input(true)


func _unhandled_input(event: InputEvent) -> void:
	# start/stop drag on left-click near its center
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and global_position.distance_to(event.position) < 24:
			dragging = true
			drag_offset = global_position - event.position
		else:
			dragging = false

	# follow the mouse while dragging
	if dragging and event is InputEventMouseMotion:
		global_position = event.position + drag_offset
