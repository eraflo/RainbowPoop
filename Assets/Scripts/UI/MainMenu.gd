extends Node

class_name MainMenu

@export var play_button_path: NodePath

var play_button: ChangeSceneButton

func _ready() -> void:
	get_tree().paused = false
	
	play_button = get_node(play_button_path)

	LevelManager.set_current_level(null)

	play_button.scene_path_to_use = LevelManager.get_next_level().level_scene_path
	play_button.button_down.connect(_init_level)

func _init_level() -> void:
	LevelManager.set_current_level(LevelManager.get_next_level())
