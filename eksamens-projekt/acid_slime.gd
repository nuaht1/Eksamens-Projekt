extends CharacterBody2D

@export var speed: float = 150.0

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	if player:
		agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if not player:
		return

	agent.target_position = player.global_position

	var direction = agent.get_next_path_position() - global_position

	if direction.length() > 1.0:
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
