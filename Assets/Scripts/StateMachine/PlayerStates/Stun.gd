extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null
var timer: Timer = null

func enter(_stateManager: StateManager):
	print("Entering Stun State")
	player = _stateManager.get_parent() as Player
	timer = Timer.new()
	timer.set_wait_time(player.stun_duration)
	timer.start()

	
func exit(_stateManager: StateManager):
	print("Exiting Stun State")

func update(_stateManager: StateManager, _delta):
	pass

func check_transition():
	if timer.is_stopped():
		return "Run"
	return null
	
