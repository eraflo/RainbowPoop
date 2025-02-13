extends Camera2D

signal get_touchscreen_input(event: InputEventScreenTouch)

var player

func _ready() -> void:
	var parent = get_parent()
	player = parent.find_child("Player", false)
	

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			get_touchscreen_input.emit(event)

func _process(delta: float) -> void:
	if player != null:
		position = player.position
