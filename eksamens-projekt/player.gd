extends CharacterBody2D

@export var speed: float = 300.0  # Movement speed

func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * speed
	move_and_slide()
