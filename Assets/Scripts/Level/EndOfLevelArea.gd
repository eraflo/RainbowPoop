extends Area2D

const Player = preload("res://Assets/Scripts/Player.gd")

@export var level_name: String = ""


func _on_body_entered(_body: Node2D) -> void:
	print("a")
	if _body is Player:
		print("b")
		# Stop counting the time score
		Score.stop_counting()
		
		print("c")
		# Stop the player
		_body.stop()

		print("d")
		# Calculate the time score
		Score.calculate_time_score()
		
		print("e")
		# Calculate the health score
		Score.calculate_health_score()
		
		print("f")
		# Multiply score by the fiber nutrient
		Score.calculate_fiber(_body._fiber.value)

		# TODO: Calculate final score with the food score
		
		print("h")
		# Play the end of level sound
		AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_LEVEL_FINISHED)

		# Play the end of level animation
		
		print("i")
		print(level_name)
		# Save the score for the level
		var level_node = get_tree().root.get_node(level_name)
		level_node.save_level_completed()
		
		print("j")
		# loads the food detail inside the ScoreDetail singleton
		ScoreDetail.sugar = _body._sugar.value
		ScoreDetail.fat = _body._fat.value
		ScoreDetail.fiber = _body._fiber.value
		ScoreDetail.protein = _body._protein.value
		ScoreDetail.vitamin = _body._vitamin.value
		ScoreDetail.water = _body._water.value
		
		
		print("k")
		# TODO: Menu to go to the next level
		get_tree().change_scene_to_file("res://Assets/Scenes/EndAnimation.tscn")
