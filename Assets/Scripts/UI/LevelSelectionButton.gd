extends Button

signal level_selected(level_data: LevelData)

@export var level_data: LevelData

func _ready() -> void:
    if LevelManager.is_level_completed(level_data.level_name):
        show()
        button_down.connect(_on_button_down)
    else:
        hide()

func _on_button_down() -> void:
    button_down.disconnect(_on_button_down)
    
    if level_data != null:
        level_selected.emit(level_data)