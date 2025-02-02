extends CharacterBody2D

signal touchscreen_input(event: InputEventScreenTouch)

const TouchscreenCamera = preload("res://Assets/Scripts/TouchscreenCamera.gd")

@export var weight: float = 50.0
@export var height: float = 1.5

# Movement
@export var gravity: float = 980
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0

# Jumping
@export var jump_force: float = 400.0

# Stun
@export var stun_duration: float = 0.5

# State manager
@onready var stateManager = $StateManager

var camera: TouchscreenCamera = null

# Current speed, affected by all kinds of factors
var current_speed: float = 0
var max_height: float = 0

func _ready() -> void:

	# Set the initial values for the Health System
	Health.weight = weight
	Health.height = height

	# Camera
	camera = get_parent().get_node("TouchscreenCamera") as TouchscreenCamera
	camera.get_touchscreen_input.connect(_on_touchscreen_input)

	# Set the initial values for the State Manager
	current_speed = max_speed
	start()
	

func _process(delta: float) -> void:
	
	# TODO: Calculate Max height based on speed and jump force
	
	
	velocity.y += gravity * delta
		
	move_and_slide()

func _on_touchscreen_input(event: InputEventScreenTouch) -> void:
	print("Player: Touchscreen input")
	touchscreen_input.emit(event)

func stop() -> void:
	stateManager.request_state("Idle")

func start() -> void:
	stateManager.request_state("Run")