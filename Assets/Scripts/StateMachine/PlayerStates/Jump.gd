
extends CharacterBody2D

@export var jump_force: float = 400.0
@export var gravity: float = 800.0
@export var max_jump_time: float = 0.3
@export var fall_gravity_multiplier: float = 1.5

var jump_time: float = 0.0
var is_jumping: bool = false

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		var gravity_force = gravity
		if velocity.y > 0 or not Input.is_action_pressed("jump"):
			gravity_force *= fall_gravity_multiplier
		velocity.y += gravity_force * delta
	
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			start_jump()
	elif is_jumping:
		continue_jump(delta)
	
	# Apply velocity
	move_and_slide()

func start_jump():
	velocity.y = -jump_force
	is_jumping = true
	jump_time = 0.0

func continue_jump(delta):
	if Input.is_action_pressed("jump") and jump_time < max_jump_time:
		velocity.y = -jump_force
		jump_time += delta
	else:
		is_jumping = false
