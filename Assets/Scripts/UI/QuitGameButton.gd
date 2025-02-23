extends Button

func _ready() -> void:
	button_down.connect(_on_button_down)

func _on_button_down() -> void:
	# Play the button click sound
	AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_BUTTON_CLICK)
	
	get_tree().quit()
