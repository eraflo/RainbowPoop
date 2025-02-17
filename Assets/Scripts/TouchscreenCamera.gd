extends Camera2D

signal get_touchscreen_input(event: InputEventScreenTouch)

var player
var path
var startedAt
var pathLength

func _ready() -> void:
	var parent = get_parent()
	player = parent.find_child("Player", false)
	path = parent.find_child("Guide", false).curve
	position = path.get_point_position(0)
	zoom = Vector2(0.15, 0.15)
	startedAt = Time.get_unix_time_from_system()
	pathLength = path.get_baked_length()

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			get_touchscreen_input.emit(event)
func _process(delta: float) -> void:
	var timeSinceStart = Time.get_unix_time_from_system()-startedAt
	if (timeSinceStart < 10):
		var coef=1-(timeSinceStart/10)
		zoom=Vector2(1-(coef*0.75), 1-(coef*0.75))
		position = path.sample_baked(((1-coef)*pathLength), true)
	else:
		position = player.position
	# print(get_viewport().get_screen_transform())
