extends CharacterBody2D

@export var speed: float = 100.0

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	if player:
		agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Continuously update target to follow player
	agent.target_position = player.global_position

	# Get the next path point
	var direction = agent.get_next_path_position() - global_position

	if direction.length() > 1.0:
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		

var can_attack = true
@export var attack_cooldown := 1.0  # seconds

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player") and can_attack:
		can_attack = false
		body.take_damage(20)
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
