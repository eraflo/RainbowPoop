extends Node2D
class_name LevelNode

@export var level_data: LevelData

var _current_score: float = 0

func _ready() -> void:
	Score.reset()
	Score.current_countdown = level_data.level_timer_countdown

func save_level_completed() -> void:
	level_data.completed = true
	level_data.score = Score.score
	ResourceSaver.save(level_data, "res://Assets/Resources/Levels/" + level_data.level_name + "Level.tres")
	
