extends ToggleVisibilityButton

class_name SettingsButton

func _ready() -> void:
	super._ready()
	button_down.connect(_on_toggle_pause)

func _on_toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
