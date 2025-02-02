extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null
var touched_screen: bool = false

func enter(state_manager: StateManager) -> void:
	player = state_manager.get_parent() as Player
	player.touchscreen_input.connect(_on_touchscreen_input)

func exit(_state_manager: StateManager) -> void:
	player.touchscreen_input.disconnect(_on_touchscreen_input)
	touched_screen = false

func update(_state_manager: StateManager, delta: float) -> void:
	if player.velocity.x < player.current_speed:
		player.velocity.x += player.acceleration * delta
	else:
		player.velocity.x = player.current_speed

func check_transition():
	if touched_screen and player.is_on_floor():
		return "Jump"
	return null

func _on_touchscreen_input(_event: InputEventScreenTouch) -> void:
	touched_screen = true
