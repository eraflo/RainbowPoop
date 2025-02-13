extends Resource

@export var levels_completed: Array = []


func is_level_completed(level_name: String) -> bool:
    for level: LevelData in levels_completed:
        if level.level_name == level_name:
            return true
    return false

func complete_new_level(level: LevelData) -> void:
    levels_completed.append(level)
    ResourceSaver.save(self, "res://Assets/Resources/Levels/LevelManager.tres")