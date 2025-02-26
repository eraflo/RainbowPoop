
class_name LevelData extends Resource

@export var level_name: String = ""
@export var level_number: int = 0
@export var level_scene_path: String = ""
@export_range(0, 4) var completion_stars: int = 0
@export var score: float = 0
@export var level_timer_countdown: float = 0
@export var completed: bool = false

@export_category("Level Decay Settings")
@export var sugar_decay: float = 0
@export var fiber_decay: float = 0
@export var protein_decay: float = 0
@export var fat_decay: float = 0
@export var water_decay: float = 0
@export var vitamin_decay: float = 0
