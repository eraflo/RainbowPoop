extends Collectable

const Player = preload("res://Assets/Scripts/Player.gd")

func _on_body_entered(body: Node) -> void:
	if body is Player:
		Score.decrement_score(score)
		queue_free()
	pass
