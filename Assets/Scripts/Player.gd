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
		# if bounce factor is between 0 and infinity
		#velocity.y = -(yvel-(yvel/bounce_factor.value))
		# if bounce factor is normalized between 0 and 1
		#velocity.y = yvel * -bounce_factor.value
		#print("vy:"+str(velocity.y)+"\t yvel:"+str(yvel))
		if velocity.y>-200:
			velocity.y=0
	
	# cancel jump if nothing has been triggering it in more than the jump delay
	if Time.get_unix_time_from_system()-jump_requested>jump_delay.value+0.1:
		jump_requested=-1
	
	# Update the stats
	_update_max_speed()
	_update_jump_force()
	_update_jump_delay()
	_update_friction()
	_update_falling_speed()
	_update_bounce_factor()
	_update_stun_duration()


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
func _add_modifier(stat: PlayerStat, value: float, type: StatModifier.StatModType, _order: int = int(type), _source: Object = null) -> void:
	stat.add_modifier(StatModifier.new(
		value,
		type,
		_order,
		_source
	))

func _update_modifier_from_source(stat: PlayerStat, source: Object, new_value: float) -> void:
	stat.update_modifier_from_source(source, new_value)

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
	_init_max_speed()
	_init_jump_force()
	_init_jump_delay()
	_init_friction()
	_init_falling_speed()
	_init_bounce_factor()
	_init_stun_duration()

## Make the stats decay over time, unless this is the first level
func _on_decay_timer_timeout() -> void:
	print(">>>>>")
	print(get_parent().name)
	print("<<<<<")
	if get_parent().name == StringName("Level0"):
		_add_modifier(_sugar, 0, StatModifier.StatModType.Flat)
		_add_modifier(_protein, 0, StatModifier.StatModType.Flat)
		_add_modifier(_fat, 0, StatModifier.StatModType.Flat)
		_add_modifier(_water, 0, StatModifier.StatModType.Flat)
		_add_modifier(_fiber, 0, StatModifier.StatModType.Flat)
		_add_modifier(_vitamin, 0, StatModifier.StatModType.Flat)
	else:
		_add_modifier(_sugar, -0.1, StatModifier.StatModType.Flat)
		_add_modifier(_protein, -0.1, StatModifier.StatModType.Flat)
		_add_modifier(_fat, -0.1, StatModifier.StatModType.Flat)
		_add_modifier(_water, -0.1, StatModifier.StatModType.Flat)
		_add_modifier(_fiber, -0.1, StatModifier.StatModType.Flat)
		_add_modifier(_vitamin, -0.1, StatModifier.StatModType.Flat)

	print("Decay")
	print("Sugar: ", _sugar.value)

	decay_timer.start()

## Initialize the stats

func _init_max_speed() -> void:
	_add_modifier(max_speed, _sugar.value, StatModifier.StatModType.Flat, 100, _sugar)
	_add_modifier(max_speed, -_protein.value, StatModifier.StatModType.Flat, 100, _protein)
	_add_modifier(max_speed, -_fat.value, StatModifier.StatModType.Flat, 100, _fat)
	_add_modifier(max_speed, _water.value, StatModifier.StatModType.Flat, 100, _water)

func _init_jump_force() -> void:
	_add_modifier(jump_force, _protein.value, StatModifier.StatModType.Flat, 100, _protein)
	_add_modifier(jump_force, -_fat.value, StatModifier.StatModType.Flat, 100, _fat)
	_add_modifier(jump_force, _water.value, StatModifier.StatModType.Flat, 100, _water)

func _init_jump_delay() -> void:
	_add_modifier(jump_delay, _sugar.value, StatModifier.StatModType.PercentMult, 100, _sugar)

func _init_friction() -> void:
	_add_modifier(friction, -_fat.value, StatModifier.StatModType.Flat, 100, _fat)

func _init_falling_speed() -> void:
	_add_modifier(falling_speed, _fat.value, StatModifier.StatModType.Flat, 100, _fat)

func _init_bounce_factor() -> void:
	_add_modifier(bounce_factor, _water.value, StatModifier.StatModType.Flat, 100, _water)

func _init_stun_duration() -> void:
	_add_modifier(stun_duration, 1 / (1 + _vitamin.value), StatModifier.StatModType.PercentMult, 100, _vitamin)

func _init_weight() -> void:
	_add_modifier(weight, _sugar.value, StatModifier.StatModType.Flat, 100, _sugar)
	_add_modifier(weight, _protein.value, StatModifier.StatModType.Flat, 100, _protein)
	_add_modifier(weight, _fat.value, StatModifier.StatModType.Flat, 100, _fat)
	_add_modifier(weight, _water.value, StatModifier.StatModType.Flat, 100, _water)
	_add_modifier(weight, _fiber.value, StatModifier.StatModType.Flat, 100, _fiber)
	_add_modifier(weight, _vitamin.value, StatModifier.StatModType.Flat, 100, _vitamin)

## Update the stats

func _update_max_speed() -> void:
	_update_modifier_from_source(max_speed, _sugar, _sugar.value)
	_update_modifier_from_source(max_speed, _protein, -_protein.value)
	_update_modifier_from_source(max_speed, _fat, -_fat.value)
	_update_modifier_from_source(max_speed, _water, _water.value)

func _update_jump_force() -> void:
	_update_modifier_from_source(jump_force, _protein, _protein.value)
	_update_modifier_from_source(jump_force, _fat, -_fat.value)
	_update_modifier_from_source(jump_force, _water, _water.value)

func _update_jump_delay() -> void:
	_update_modifier_from_source(jump_delay, _sugar, _sugar.value)

func _update_friction() -> void:
	_update_modifier_from_source(friction, _fat, -_fat.value)

func _update_falling_speed() -> void:
	_update_modifier_from_source(falling_speed, _fat, _fat.value)

func _update_bounce_factor() -> void:
	_update_modifier_from_source(bounce_factor, _water, _water.value)

func _update_stun_duration() -> void:
	_update_modifier_from_source(stun_duration, _vitamin, 1 / (1 + _vitamin.value))
