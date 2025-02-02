extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null

func enter(_stateManager: StateManager):
	print("Entering Idle State")
	player = _stateManager.get_parent() as Player
	player.velocity = Vector2(0, 0)

func exit(_stateManager: StateManager):
	print("Exiting Idle State")

func update(_stateManager: StateManager, _delta):
	pass

func check_transition():
	return null
