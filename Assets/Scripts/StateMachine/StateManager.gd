extends Node
class_name StateManager

var current_state: State = null

func _ready() -> void:
	for child in get_children():
		if child is State:
			current_state = child
			current_state.enter(self)
			break

func _process(delta):
	if current_state:
		# Check the next state to transition to
		var new_state_name = current_state.check_transition()
		if new_state_name:
			transition_to(new_state_name)
		
		# Update the current state
		current_state.update(self, delta)

func transition_to(new_state_name):
	var new_state = get_node_or_null(new_state_name)
	if new_state and new_state != current_state:
		if current_state:
			current_state.exit(self)
		current_state = new_state
		current_state.enter(self)
		
func request_state(state_name):
	transition_to(state_name)
