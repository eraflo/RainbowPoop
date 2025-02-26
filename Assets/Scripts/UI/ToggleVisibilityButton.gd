extends Button

class_name ToggleVisibilityButton

@export var elementToToggle: NodePath = ""

var element: Node


func _ready() -> void:
	element = get_node(elementToToggle)
	button_down.connect(_on_button_down)


func _on_button_down() -> void:

	AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_BUTTON_CLICK)

	print("Button down")

	if element.is_visible():
		element.hide()
	else:
		element.show()
