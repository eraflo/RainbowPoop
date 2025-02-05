extends Area2D

const Player = preload("res://Assets/Scripts/Player.gd")

@export var level_name: String = ""


func _on_body_entered(_body: Node2D) -> void:
	if _body is Player:
		# Stop counting the time score
		Score.stop_counting()

		# Stop the player
		_body.stop()

		# Calculate the time score
		Score.calculate_time_score()

		# Calculate the health score
		Score.calculate_health_score()

		# Multiply score by the fiber nutrient
		Score.calculate_fiber(_body._fiber.value)

		# TODO: Calculate final score with the food score

		# TODO: Play the end of level animation

		# Save the score for the level
		var level_node = get_tree().root.get_node(level_name)
		level_node.save_level_completed()
