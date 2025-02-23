extends Control

@export_category("Level UI")
@export var allLevelUI: Array[LevelSelectionButton] = []

@export_category("Tab UI")
@export var titleLabel: Label = null
@export var starsContainer: Container = null
@export var bestScoreLabel: Label = null
@export var startButton: ChangeSceneButton = null

@export_category("Stars Sprites")
@export var starSprite: Texture = null
@export var emptyStarSprite: Texture = null

var selectedLevel: LevelData = null

func _ready() -> void:
	for levelUI in allLevelUI:
		levelUI.level_selected.connect(_on_level_selected)
		levelUI.level_unselected.connect(_on_level_unselected)

func _on_level_selected(level_data: LevelData) -> void:
	selectedLevel = level_data
	for levelUI in allLevelUI:
		if levelUI.level_data != level_data and levelUI.isVisible:
			levelUI.unselected()
	
	show()

	titleLabel.text = selectedLevel.level_name
	bestScoreLabel.text = "Best Score : " + str(selectedLevel.score)
	startButton.scene_path = selectedLevel.level_scene_path

	# Remove all the stars, then add the correct amount of stars and empty stars
	for i in range(starsContainer.get_child_count()):
		starsContainer.remove_child(starsContainer.get_child(0))

	for i in range(selectedLevel.completion_stars):
		var starSpriteInstance = TextureRect.new()
		starSpriteInstance.texture = starSprite
		starsContainer.add_child(starSpriteInstance)

	for i in range(4 - selectedLevel.completion_stars):
		var starSpriteInstance = TextureRect.new()
		starSpriteInstance.texture = emptyStarSprite
		starsContainer.add_child(starSpriteInstance)
	
	# Make last star bigger
	var lastStar: TextureRect = starsContainer.get_child(starsContainer.get_child_count() - 1)
	lastStar.custom_minimum_size = Vector2(64, 64)


	


func _on_level_unselected(level_data: LevelData) -> void:
	hide()
