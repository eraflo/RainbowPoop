extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null

var max_height: float = 0
var current_height: float = 0

func enter(state_manager: StateManager) -> void:
	player = state_manager.get_parent() as Player

	max_height = player.position.y

	player.velocity.y -= player.jump_force

func exit(_state_manager: StateManager) -> void:
	pass

func update(_state_manager: StateManager, _delta: float) -> void:
	pass

func check_transition():
	if player.is_on_floor():
		return "Run"
	return null

