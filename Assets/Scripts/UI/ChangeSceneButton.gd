extends Button

class_name ChangeSceneButton

@export var scene_path: String


func _ready() -> void:
	button_down.connect(_on_button_down)


func _on_button_down() -> void:
	if scene_path != "":
		get_tree().change_scene_to_file(scene_path)
