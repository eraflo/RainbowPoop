extends CharacterBody2D

@export var gravity: float = 980  # Add this line to define gravity (980 is a common value)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	# gravity
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	move_and_slide()
	
