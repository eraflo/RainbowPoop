extends CharacterBody2D

signal get_touchscreen_input(event: InputEventScreenTouch)

@export var gravity: float = 980
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var jump_force: float = -400.0

@export var stun_duration: float = 0.5

@onready var stateManager = $StateManager

# Current speed, affected by all kinds of factors
var current_speed: float = 0

func _ready() -> void:
	current_speed = max_speed
	stateManager.request_state("Run")
	

func _process(delta: float) -> void:
	
	# gravity
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		get_touchscreen_input.emit(event)
