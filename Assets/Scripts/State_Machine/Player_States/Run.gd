extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null
var touched_screen: bool = false

func enter(_stateManager: StateManager) -> void:
	player = _stateManager.get_parent() as Player
	player.touchscreen_input.connect(_on_touchscreen_input)

func exit(_stateManager: StateManager) -> void:
	player.touchscreen_input.disconnect(_on_touchscreen_input)
	touched_screen = false

func update(_state_manager: StateManager, delta: float) -> void:

	# Move the player (player.velocity.x is the speed of the player minus the friction)
	if player.velocity.x < player.max_speed.value:
		player.velocity.x += (player.acceleration - player.friction.value) * delta 
	else:
		player.velocity.x = player.max_speed.value



func check_transition():
	if touched_screen and player.is_on_floor():
		return "Jump"
	return null

## This function is called when the player touches the screen
func _on_touchscreen_input(_event: InputEventScreenTouch) -> void:
	touched_screen = true
