extends State

func enter(_stateManager: StateManager):
	print("Entering Idle State")

func exit(_stateManager: StateManager):
	print("Exiting Idle State")

func update(_stateManager: StateManager, _delta):
	pass

func check_transition():
	return null
