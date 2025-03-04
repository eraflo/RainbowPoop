extends Node

class_name MainMenu

@export var play_button_path: NodePath

var play_button: ChangeSceneButton

var main_music: AudioStreamPlayer

var game_was_paused: bool = false

func _ready() -> void:

	if get_tree().paused:
		game_was_paused = true

	get_tree().paused = false

	if game_was_paused:
		AudioManager.stopAllAudio()
	
	play_button = get_node(play_button_path)

	LevelManager.set_current_level(null)

	play_button.scene_path_to_use = LevelManager.get_next_level().level_scene_path
	play_button.button_down.connect(_init_level)

	AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_RAINBOW_POOP_SPEAK, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_RAINBOW_POOP_SPEAK) - 1)
	
	if not AudioManager.isAudioPlayed(AudioEffectSettings.AudioEffectType.ON_START_MENU_MUSIC):
		main_music = AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_START_MENU_MUSIC, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_START_MENU_MUSIC) - 1)
		main_music.finished.connect(_on_music_finished)


func _init_level() -> void:
	LevelManager.set_current_level(LevelManager.get_next_level())

	AudioManager.stopAudio(AudioEffectSettings.AudioEffectType.ON_START_MENU_MUSIC)


func _on_music_finished() -> void:
	main_music = AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_START_MENU_MUSIC, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_START_MENU_MUSIC) - 1)
	main_music.finished.connect(_on_music_finished)
 
