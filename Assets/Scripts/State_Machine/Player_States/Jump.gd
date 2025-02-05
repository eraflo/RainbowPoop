extends State

const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player = null
var _timer: Timer = null

func enter(_stateManager: StateManager) -> void:
	player = _stateManager.get_parent() as Player

	if player.jump_delay.value > 0:
		_timer = Timer.new()

		add_child(_timer)

		_timer.set_wait_time(player.jump_delay.value)
		_timer.set_one_shot(true)
		_timer.timeout.connect(_delay_in_jump)

		_timer.start()
	else:
		_jump()

func exit(_stateManager: StateManager) -> void:
	pass

func update(_stateManager: StateManager, _delta: float) -> void:
	
	if player.velocity.x < player.max_speed.value:
		player.velocity.x += player.acceleration * _delta
	else:
		player.velocity.x = player.max_speed.value

func check_transition():
	if player.is_on_floor():
		return "Run"
	return null

func _delay_in_jump():
	_jump()
	_timer.stop()
	_timer.queue_free()

func _jump():

	# var max_height = player.jump_force.value * player.jump_force.value / (2 * player.gravity)
	# var v0 = sqrt(2 * player.gravity * max_height)
	# var f_average = (1/2 * player.weight.value * v0 * v0) / max_height
	# var f_tot = f_average + player.gravity * player.weight.value
	# player.velocity.y -= f_tot
	player.velocity.y -= player.jump_force.value
