extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null
var _timer: Timer = null
var touched_screen: bool = false
var lastWall = 0

func enter(_stateManager: StateManager) -> void:
	print("Player: SlideDown")
	player = _stateManager.get_parent() as Player
	lastWall = Time.get_unix_time_from_system()

func exit(_stateManager: StateManager) -> void:
	pass

func update(_stateManager: StateManager, _delta: float) -> void:
	
	if player.velocity.x < player.max_speed.value:
		player.velocity.x += player.acceleration * _delta
	else:
		player.velocity.x = player.max_speed.value

func check_transition():
	var t = Time.get_unix_time_from_system()
	if player.is_on_floor():
		return "Run"
	# if the player want to jump, and enough time has passed since the delay,
	# jump and change direction
	if (player.jump_requested>0):
		if (t-player.jump_requested>player.jump_delay.value):
			player.jump_requested=-1
			if WorldDirection.direction == WorldDirection.Direction.LEFT:
				WorldDirection.direction=WorldDirection.Direction.RIGHT
				player.velocity.x =  player.max_speed.value
			else:
				WorldDirection.direction=WorldDirection.Direction.LEFT
				player.velocity.x = - player.max_speed.value
			return "Jump"
	# Little delay befor running again when the player stops coliding with a wall
	if not player.is_on_wall():
		if t-lastWall>0.5:
			return "Run"
	else:
			lastWall = t
	return null

func _on_touchscreen_input(_event: InputEventScreenTouch) -> void:
	touched_screen = true
