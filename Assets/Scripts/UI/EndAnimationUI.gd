extends Node

class_name EndAnimationUI

@export var nextLevelButtonPath: NodePath

var nextLevel: LevelData
var nextLevelButton: ChangeSceneButton

func _ready() -> void:
	nextLevelButton = get_node(nextLevelButtonPath)

	if LevelManager.get_current_level().completion_stars < 1:
		AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_LOSE, randi_range(0, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_LOSE) - 1))
	elif LevelManager.get_current_level().completion_stars < 4:
		AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_WIN, randi_range(0, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_WIN) - 1))
	else:
		AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_SPECIAL_WIN, randi_range(0, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_SPECIAL_WIN) - 1))

	nextLevel = LevelManager.get_next_level()
	nextLevelButton.scene_path_to_use = nextLevel.level_scene_path
