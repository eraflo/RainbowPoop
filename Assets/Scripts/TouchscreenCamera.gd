extends Camera2D

signal get_touchscreen_input(event: InputEventScreenTouch)

var player
var path
var startedAt
var pathLength
const ANIMATION_DURATION = 5

func _ready() -> void:
	var parent = get_parent()
	player = parent.find_child("Player", false)
	zoom = Vector2(0.15, 0.15)
	startedAt = Time.get_unix_time_from_system()
	
	path = parent.find_child("Guide", false).curve
	pathLength = path.get_baked_length()
	position = path.get_point_position(0)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			get_touchscreen_input.emit(event)

func _process(delta: float) -> void:
	var timeSinceStart = Time.get_unix_time_from_system()-startedAt
	if (timeSinceStart < ANIMATION_DURATION):
		var coef=1-(timeSinceStart/ANIMATION_DURATION)
		position = path.sample_baked(((1-coef)*pathLength), true)
	elif (timeSinceStart < ANIMATION_DURATION+0.75):
		zoom = Vector2(timeSinceStart-ANIMATION_DURATION+0.25,timeSinceStart-ANIMATION_DURATION+0.25)
			
	else:
		position = player.position
	# print(get_viewport().get_screen_transform())
