extends Node2D
class_name LevelNode

@export var level_data: LevelData

var main_music: AudioStreamPlayer

func _ready() -> void:
	Score.reset()
	Score.current_countdown = level_data.level_timer_countdown

	main_music = AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_MAIN_MUSIC, randi_range(0, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_MAIN_MUSIC) - 1))
	main_music.finished.connect(_on_music_finished)


func save_level_completed() -> void:
	level_data.completed = true

	if Score.score > level_data.score:
		level_data.score = Score.score
	
	var fileName = level_data.level_name.replace(" ", "")
	
	ResourceSaver.save(level_data, "res://Assets/Resources/Levels/" + fileName + ".tres")

	if not LevelManager.is_level_completed(level_data.level_name):
		LevelManager.complete_new_level(level_data)
	

func _on_music_finished() -> void:
	main_music = AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_MAIN_MUSIC, randi_range(0, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_MAIN_MUSIC) - 1))
	main_music.finished.connect(_on_music_finished)
