extends ImageCompositeButton

class_name LevelSelectionButton

signal level_selected(level_data: LevelData)
signal level_unselected(level_data: LevelData)

@export var level_data: LevelData

func _ready() -> void:
	if level_data == null:
		printerr("LevelSelectionButton: level_data is null")
		return


	if LevelManager.is_level_completed(level_data.level_name) or LevelManager.get_next_level() == level_data:
		isVisible = true
	else:
		isVisible = false
	
	button_down.connect(_on_button_down)
	super._ready()

func _on_button_down() -> void:

	AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_BUTTON_CLICK)

	if level_data != null && isVisible && !isSelected:
		level_selected.emit(level_data)
	elif level_data != null && isVisible && isSelected:
		level_unselected.emit(level_data)
	
