extends CharacterBody2D

signal touchscreen_input(event: InputEventScreenTouch)
signal got_collision(collision: KinematicCollision2D)

const TouchscreenCamera = preload("res://Assets/Scripts/TouchscreenCamera.gd")


@export var weight: PlayerStat
@export var height: PlayerStat

# Movement
@export var gravity: float = 980
@export var acceleration: float = 800.0

# Food
@export var food_eaten: Array = []

@export var max_speed: PlayerStat
@export var jump_force: PlayerStat
@export var jump_delay: PlayerStat 
@export var friction: PlayerStat
@export var falling_speed: PlayerStat
@export var bounce_factor: PlayerStat
@export var stun_duration: PlayerStat

# check if the player requested a jump, and when
var jump_requested: float = -1

var _sugar: PlayerStat
var _protein: PlayerStat
var _fat: PlayerStat
var _water: PlayerStat
var _fiber: PlayerStat
var _vitamin: PlayerStat

# State manager
@onready var stateManager = $StateManager

var camera: TouchscreenCamera = null
var decay_timer: Timer = null

# Current speed, affected by all kinds of factors
var current_speed: float = 0

func _ready() -> void:

	# Reference to obstacle manager so that every obstacle can access the player
	ObstacleManager.player = self

	# Camera
	camera = get_parent().get_node("TouchscreenCamera") as TouchscreenCamera
	camera.get_touchscreen_input.connect(_on_touchscreen_input)

	reset()
	
	start()

	# Decay timer
	decay_timer = Timer.new()
	add_child(decay_timer)

	decay_timer.set_wait_time(1)
	decay_timer.set_one_shot(false)
	decay_timer.timeout.connect(_on_decay_timer_timeout)

	decay_timer.start()
	

func _process(delta: float) -> void:
	
	# Apply gravity
	velocity.y += gravity * delta * falling_speed.value

	# print("Max speed: ", max_speed.value)
	# print("Jump force: ", jump_force.value)
	# print("Jump delay: ", jump_delay.value)
	# print("Friction: ", friction.value)
	# print("Falling speed: ", falling_speed.value)
	# print("Bounce factor: ", bounce_factor.value)
	# print("Stun duration: ", stun_duration.value)
	# print("Weight: ", weight.value)
	# print(("--------------------"))
	
	# retrieve the value of the y velocity before we touch the ground, in case we need to bounce
	var yvel = velocity.y
	
	# move and compute collisions
	move_and_slide()

	## Emit the collision signal
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		got_collision.emit(collision)
	if is_on_floor():
		velocity.y = yvel * -bounce_factor.value


## Make the player began behaving as a player
func start() -> void:
	stateManager.request_state("Run")

## Reset the player stats
func reset():
	_setup_stats()

## Stop the player from behaving as a player
func stop() -> void:
	stateManager.request_state("Idle")

## Eat a food
func eat_food(food: Food) -> void:
	food_eaten.append(food)

	_add_modifier(_sugar, food.sugar, StatModifier.StatModType.Flat)
	_add_modifier(_protein, food.protein, StatModifier.StatModType.Flat)
	_add_modifier(_fat, food.fat, StatModifier.StatModType.Flat)
	_add_modifier(_water, food.water, StatModifier.StatModType.Flat)
	_add_modifier(_fiber, food.fiber, StatModifier.StatModType.Flat)
	_add_modifier(_vitamin, food.vitamin, StatModifier.StatModType.Flat)
	


## Handle the touchscreen input
func _on_touchscreen_input(event: InputEventScreenTouch) -> void:
	print("Player: Touchscreen input")
	touchscreen_input.emit(event)
	if jump_requested<0:
		jump_requested= Time.get_unix_time_from_system()


## Add a modifier to a stat
func _add_modifier(stat: PlayerStat, value: float, type: StatModifier.StatModType) -> void:
	stat.add_modifier(StatModifier.new(
		value,
		type
	))

## Setup the stats based on the food eaten
func _setup_stats() -> void:

	# Setup food stats
	_sugar = PlayerStat.new()
	_protein = PlayerStat.new()
	_fat = PlayerStat.new()
	_water = PlayerStat.new()
	_fiber = PlayerStat.new()
	_vitamin = PlayerStat.new()

	# Set the base values for the food stats (TODO: Ask Xiaolan for right ratios)
	_sugar.base_value = 10
	_protein.base_value = 10
	_fat.base_value = 10
	_water.base_value = 10
	_fiber.base_value = 10
	_vitamin.base_value = 10
	
	# Set the stats based on the food eaten
	_add_modifier(max_speed, _sugar.value - _protein.value - _fat.value + _water.value, StatModifier.StatModType.Flat)
	_add_modifier(jump_force, _protein.value - _fat.value + _water.value, StatModifier.StatModType.Flat)

	# Formula = base jump delay * (1.0 + sugar)
	_add_modifier(jump_delay, _sugar.value, StatModifier.StatModType.PercentMult)
	_add_modifier(friction, -_fat.value, StatModifier.StatModType.Flat)
	_add_modifier(falling_speed, _fat.value, StatModifier.StatModType.Flat)
	_add_modifier(bounce_factor, _water.value, StatModifier.StatModType.Flat)

	# Formula = base stun * (1.0 / (1.0 + vitamin))
	_add_modifier(stun_duration, 1 / (1 + _vitamin.value), StatModifier.StatModType.PercentMult)

	# Weight
	_add_modifier(weight, _sugar.value + _protein.value + _fat.value + _water.value + _fiber.value + _vitamin.value, StatModifier.StatModType.Flat)

## Make the stats decay over time
func _on_decay_timer_timeout() -> void:
	_add_modifier(_sugar, -0.1, StatModifier.StatModType.Flat)
	_add_modifier(_protein, -0.1, StatModifier.StatModType.Flat)
	_add_modifier(_fat, -0.1, StatModifier.StatModType.Flat)
	_add_modifier(_water, -0.1, StatModifier.StatModType.Flat)
	_add_modifier(_fiber, -0.1, StatModifier.StatModType.Flat)
	_add_modifier(_vitamin, -0.1, StatModifier.StatModType.Flat)

	decay_timer.start()
