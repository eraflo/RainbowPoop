extends CharacterBody2D

enum Status 
{ 
	IDLE = 0, 
	WALK = 1, 
	JUMP = 2, 
	FALL = 3, 
	SLIDE_UP = 4, 
	SLIDE_DOWN = 5, 
	STUN = 6 
}

@export var gravity: float = 980  # Add this line to define gravity (980 is a common value)

@export var status: Status = Status.IDLE


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	print(status)

func _physics_process(delta: float) -> void:
	
	# gravity
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	move_and_slide()
	
func change_status(new_status: Status) -> void:
	status = new_status

func apply_knockback(knockback_dir: Vector2, knockback_force: float) -> void:
	velocity = knockback_dir * knockback_force
	status = Status.STUN
