extends Button

class_name ChangeSceneButton

@export var scene_path: String = ""

var scene_path_to_use: String = ""


func _ready() -> void:
	if scene_path_to_use == "" and scene_path != "":
		scene_path_to_use = scene_path
	
	button_down.connect(_on_button_down)


func _on_button_down() -> void:

	AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_BUTTON_CLICK)
	
	if scene_path_to_use != "":
		AudioManager.stopAudio(AudioEffectSettings.AudioEffectType.ON_MAIN_MUSIC)
		Health.weight = null
		get_tree().change_scene_to_file(scene_path_to_use)
