extends Sprite2D

@export var element: String = ""      # will be “H” or “O”  
var dragging := false  
var drag_offset := Vector2.ZERO      # no longer called “offset”!

func _ready() -> void:
	# so _unhandled_input() still sees clicks even under Control
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	# mouse button: begin/end drag
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and global_position.distance_to(event.position) < 32:
			dragging = true
			drag_offset = global_position - event.position
		else:
			dragging = false

	# mouse motion while dragging: follow cursor
	if dragging and event is InputEventMouseMotion:
		global_position = event.position + drag_offset
