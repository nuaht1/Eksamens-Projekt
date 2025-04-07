extends CharacterBody2D

@onready var health_bar = get_node("/root/Node2D/UI/HealthBar")

@export var move_speed: float = 200.0
@export var max_health: int = 100

var current_health: int

func _ready() -> void:
	current_health = max_health
	update_health_bar()

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * move_speed
	move_and_slide()

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Player took", amount, "damage. Health now:", current_health)

	if current_health < 0:
		current_health = 0

	update_health_bar()

	if current_health <= 0:
		die()

func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health
