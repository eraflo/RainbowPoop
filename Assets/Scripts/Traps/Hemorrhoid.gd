extends Obstacle

@export var score_decrease: float = 10

func _on_collision_entered(_body: Node) -> void:
	print(_body)
	if _body is Player:
		# Decrement the score
		Score.decrement_score(score_decrease)

		
		# TODO: Play animation

		# TODO: Play sound

		queue_free()    # Destroy the obstacle

func _on_collision_exited(_body: Node) -> void:
	pass
