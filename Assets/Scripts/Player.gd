extends CharacterBody2D

signal touchscreen_input(event: InputEventScreenTouch)

const TouchscreenCamera = preload("res://Assets/Scripts/TouchscreenCamera.gd")


@export var weight: float = 50.0
@export var height: float = 1.5

# Movement
@export var gravity: float = 980
@export var acceleration: float = 800.0

# Food
@export var food_eaten: Array = []

@export var max_speed: PlayerStat
@export var jump_force: PlayerStat
@export var friction: PlayerStat
@export var falling_speed: PlayerStat
@export var bounce_factor: PlayerStat
@export var stat_drain: PlayerStat
@export var vision_fog: PlayerStat
@export var stun_duration: PlayerStat

# State manager
@onready var stateManager = $StateManager

var camera: TouchscreenCamera = null

# Current speed, affected by all kinds of factors
var current_speed: float = 0

func _ready() -> void:

	# Camera
	camera = get_parent().get_node("TouchscreenCamera") as TouchscreenCamera
	camera.get_touchscreen_input.connect(_on_touchscreen_input)

	_reset()
	
	start()
	

func _process(delta: float) -> void:
	
	# TODO: Calculate Max height based on speed and jump force
	
	velocity.y += gravity * delta

	# print("Max Speed: ", max_speed.value)
	# print("Jump Force: ", jump_force.value)
	# print("Friction: ", friction.value)
	# print("Falling Speed: ", falling_speed.value)
	# print("Bounce Factor: ", bounce_factor.value)
	# print("Stun Duration: ", stun_duration.value)
	# print("Stat Drain: ", stat_drain.value)
	# print("Vision Fog: ", vision_fog.value)
	# print("--------------------")
		
	move_and_slide()

func _on_touchscreen_input(event: InputEventScreenTouch) -> void:
	print("Player: Touchscreen input")
	touchscreen_input.emit(event)

## Reset the player stats
func _reset():
	# Set the initial values for the Health System
	Health.weight = weight
	Health.height = height

	# Add stat drain modifier to each stat
	max_speed.add_modifier(StatModifier.new(
		-stat_drain.value,
		StatModifier.StatModType.Flat
	))

	jump_force.add_modifier(StatModifier.new(
		-stat_drain.value,
		StatModifier.StatModType.Flat
	))

	friction.add_modifier(StatModifier.new(
		-stat_drain.value,
		StatModifier.StatModType.Flat
	))

	falling_speed.add_modifier(StatModifier.new(
		stat_drain.value,
		StatModifier.StatModType.Flat
	))

	bounce_factor.add_modifier(StatModifier.new(
		stat_drain.value,
		StatModifier.StatModType.Flat
	))

	stun_duration.add_modifier(StatModifier.new(
		stat_drain.value,
		StatModifier.StatModType.Flat
	))


func stop() -> void:
	stateManager.request_state("Idle")

func start() -> void:
	stateManager.request_state("Run")

func eat_food(food: Food) -> void:
	food_eaten.append(food)

	Health.add_weight(food.weight)

	max_speed.add_modifier(StatModifier.new(
		food.sugar - food.protein - food.fat + food.water,
		StatModifier.StatModType.Flat
	))

	jump_force.add_modifier(StatModifier.new(
		food.protein - food.fat + food.water,
		StatModifier.StatModType.Flat
	))

	friction.add_modifier(StatModifier.new(
		-food.fat,
		StatModifier.StatModType.Flat
	))

	falling_speed.add_modifier(StatModifier.new(
		food.fat,
		StatModifier.StatModType.Flat
	))

	bounce_factor.add_modifier(StatModifier.new(
		food.water,
		StatModifier.StatModType.Flat
	))

	stun_duration.add_modifier(StatModifier.new(
		food.vitamin,
		StatModifier.StatModType.Flat
	))
