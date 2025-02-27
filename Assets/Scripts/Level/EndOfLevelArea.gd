extends Area2D

const Player = preload("res://Assets/Scripts/Player.gd")

@export var level_name: String = ""


func _on_body_entered(_body: Node2D) -> void:
	if _body is Player:
		# Stop counting the time score
		Score.stop_counting()

		# Stop the player
		_body.stop()

		# Stop main music
		AudioManager.stopAudio(AudioEffectSettings.AudioEffectType.ON_MAIN_MUSIC)

		print("Score before calculating: " + str(Score.score))

		# Calculate the time score
		Score.calculate_time_score()

		print("Score after calculating time: " + str(Score.score))

		# Calculate the health score
		Score.calculate_health_score()

		print("Score after calculating health: " + str(Score.score))

		# Multiply score by the fiber nutrient
		Score.calculate_fiber(_body._fiber.value)

		print("Score after calculating fiber: " + str(Score.score))

		# TODO: Calculate final score with the food score
		
		# Play the end of level sound
		AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_LEVEL_FINISHED, randi_range(0, AudioManager.getNumberOfAudioForType(AudioEffectSettings.AudioEffectType.ON_LEVEL_FINISHED) - 1))

		var level_node = get_tree().root.get_node(level_name)

		# TODO: Base on win or not, play the win or lose sound
		var completionScore = Score.score
		var stars = 0
		if completionScore >= level_node.level_data.oneStarScore:
			stars = 1
		
		if completionScore >= level_node.level_data.twoStarScore:
			stars = 2

		if completionScore >= level_node.level_data.threeStarScore:
			stars = 3
		
		if Health.health_status == Health.HealthStatus.NORMAL && stars == 3:
			stars = 4		

		level_node.level_data.completion_stars = stars
		
		# Save the score for the level
		level_node.save_level_completed()

		# TODO: Menu to go to the next level
		get_tree().change_scene_to_file("res://Assets/Scenes/EndAnimation.tscn")
