extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null

var max_height: float = 0
var current_height: float = 0

func enter(_stateManager: StateManager) -> void:
	player = _stateManager.get_parent() as Player

	max_height = player.position.y

	player.velocity.y -= player.jump_force.value

func exit(_stateManager: StateManager) -> void:
	pass

func update(_stateManager: StateManager, _delta: float) -> void:
	pass

func check_transition():
	if player.is_on_floor():
		return "Run"
	return null

