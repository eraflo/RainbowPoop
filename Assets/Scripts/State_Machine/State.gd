extends Node
class_name State

func enter(_stateManager: StateManager):
	printerr("Need to implement enter() in inherited class")

func exit(_stateManager: StateManager):
	printerr("Need to implement exit() in inherited class")

func update(_stateManager: StateManager, _delta):
	printerr("Need to implement update() in inherited class")

## Returns the name of the next state to transition to
func check_transition():
	return null
