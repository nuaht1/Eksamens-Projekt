extends Area2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Ensure this Area2D actually monitors bodies
	monitoring = true

	# Prepare a Callable to our handler
	var cb = Callable(self, "_on_body_entered")
	# Only connect once
	if not is_connected("body_entered", cb):
		connect("body_entered", cb)

	# Debug print so we know it loaded
	print("WaterSpell ready; layer:", collision_layer, " mask:", collision_mask)

func _physics_process(delta: float) -> void:
	# Move
	position += direction * speed * delta

	# Auto‐free if offscreen
	if not get_viewport_rect().has_point(global_position):
		print("WaterSpell offscreen, freeing")
		queue_free()

func _on_body_entered(body: Node) -> void:
	print("WaterSpell collided with:", body.name, " in group enemy?", body.is_in_group("enemy"))
	if body.is_in_group("enemy"):
		print(" → hit an enemy, calling take_damage()")
		body.take_damage(20)
	# In any case, destroy the spell
	queue_free()
