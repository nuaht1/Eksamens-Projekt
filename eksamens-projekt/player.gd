# player.gd
extends CharacterBody2D

# ——————————————————————————————————————————————————————————————
# UI & Health
@onready var health_bar = get_node("/root/Node2D/UI/HealthBar")
@export var max_health: int = 100
var current_health: int

# ——————————————————————————————————————————————————————————————
# Movement
@export var move_speed: float = 200.0

# ——————————————————————————————————————————————————————————————
# WaterSpell
# Preload your projectile scene (rename your .tscn to WaterSpell.tscn)
var WaterSpellScene: PackedScene = preload("res://water_spell.tscn")

func _ready() -> void:
	current_health = max_health
	update_health_bar()

func _physics_process(_delta: float) -> void:
	# PLAYER MOVEMENT
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

func _input(event: InputEvent) -> void:
	# WATER SPELL ON LEFT CLICK
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var spell = WaterSpellScene.instantiate()
			# Add it into the same parent as the player (world)
			get_parent().add_child(spell)
			# Spawn at the player's position
			spell.global_position = global_position
			# Aim toward the mouse
			var to_mouse = (get_global_mouse_position() - global_position).normalized()
			spell.direction = to_mouse

# ——————————————————————————————————————————————————————————————
# DAMAGE & DEATH

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0
	print("Player took", amount, "damage — now at", current_health)
	update_health_bar()
	if current_health == 0:
		die()

func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()

func update_health_bar() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
