extends Camera2D

signal get_touchscreen_input(event: InputEventScreenTouch)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			get_touchscreen_input.emit(event)
