extends CharacterBody2D  # Change this from Node to CharacterBody2D

@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var gravity: float = 800.0
@export var jump_force: float = -400.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize any necessary components or variables here
	pass

# Called every physics frame. 'delta' is the fixed time step.
func _physics_process(delta: float) -> void:
	# Implement your auto-run system here
	if velocity.x < max_speed:
		velocity.x += acceleration * delta
	else:
		velocity.x = max_speed
	
	# Apply gravity
	velocity.y += gravity * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Move the character
	move_and_slide()

	# Update velocity after move_and_slide
	velocity = velocity

# You can keep _process for non-physics updates if needed
func _process(delta: float) -> void:
	# Handle any non-physics related updates here (e.g., UI updates)
	pass
