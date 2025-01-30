extends CharacterBody2D

@export var gravity: float = 980
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var jump_force: float = -400.0

@onready var stateManager = $StateManager


func _ready() -> void:
	stateManager.request_state("Run")
	

func _process(delta: float) -> void:
	
	# gravity
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	move_and_slide()
