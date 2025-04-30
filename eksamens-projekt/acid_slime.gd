extends CharacterBody2D

@export var speed: float = 100.0
@export var max_health: int = 100

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

var current_health: int
var can_attack: bool = true
@export var attack_cooldown: float = 1.0  # seconds

func _ready() -> void:
	# Initialize health and enemy group
	current_health = max_health
	add_to_group("enemy")

	# First path target
	if player:
		agent.target_position = player.global_position

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Continuously chase the player
	agent.target_position = player.global_position
	var dir = agent.get_next_path_position() - global_position
	if dir.length() > 1.0:
		velocity = dir.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _on_area_2d_body_entered(body: Node) -> void:
	# Enemy melee damage with cooldown
	if body.is_in_group("player") and can_attack:
		can_attack = false
		body.take_damage(20)
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(amount: int) -> void:
	# Called by WaterSpell or other attacks
	current_health -= amount
	print("Slime took %d damage, health now %d" % [amount, current_health])
	if current_health <= 0:
		die()
		# e.g. in your Enemy.gd, when health <= 0:
		ScoreManager.add_score(1)  # or whatever point value
		queue_free()


func die() -> void:
	# You could spawn particles or play a sound here
	queue_free()
