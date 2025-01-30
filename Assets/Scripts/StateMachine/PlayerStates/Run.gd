extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null

func enter(state_manager: StateManager) -> void:
	player = state_manager.get_parent() as Player

func exit(_add_constant_torquestate_manager: StateManager) -> void:
	pass

func update(_state_manager: StateManager, delta: float) -> void:

	if player.velocity.x < player.max_speed:
		player.velocity.x += player.acceleration * delta
	else:
		player.velocity.x = player.max_speed

func check_transition():
	if Input.is_action_just_pressed("touchscreen") and player.is_on_floor():
		return "Jump"
	return null
