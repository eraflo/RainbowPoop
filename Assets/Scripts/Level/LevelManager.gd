extends Node2D

var _levelManagerData: LevelManagerData = null

var _currentLevel: LevelData = null 

func _ready() -> void:
    _levelManagerData = ResourceLoader.load("res://Assets/Resources/Levels/LevelManagerData.tres")

    sort_all_levels()

func get_current_level() -> LevelData:
    return _currentLevel

func set_current_level(level: LevelData) -> void:
    _currentLevel = level

func is_level_completed(level_name: String) -> bool:
    for level: LevelData in _levelManagerData.levels_completed:
        if level.level_name == level_name:
            return true
    return false

func sort_all_levels() -> void:
    _levelManagerData.all_levels.sort_custom(func(x, y): return x.level_number < y.level_number)

func get_next_level() -> LevelData:
    var next_level: LevelData = null

    sort_all_levels()

    for level: LevelData in _levelManagerData.all_levels:
        if not is_level_completed(level.level_name):
            next_level = level
            break
    return next_level

func complete_new_level(level: LevelData) -> void:
    _levelManagerData.levels_completed.append(level)
    ResourceSaver.save(_levelManagerData, "res://Assets/Resources/Levels/LevelManagerData.tres")