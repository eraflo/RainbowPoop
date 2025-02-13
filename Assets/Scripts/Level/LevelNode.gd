extends Node2D
class_name LevelNode

@export var level_data: LevelData

func _ready() -> void:
	Score.reset()
	Score.current_countdown = level_data.level_timer_countdown

func save_level_completed() -> void:
	level_data.completed = true
	level_data.score = Score.score
	ResourceSaver.save(level_data, "res://Assets/Resources/Levels/" + level_data.level_name + "Level.tres")

	if not LevelManager.is_level_completed(level_data.level_name):
		LevelManager.complete_new_level(level_data)
	
