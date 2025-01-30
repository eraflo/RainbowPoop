extends Obstacle

const Player = preload("res://Assets/Scripts/Player.gd")

@export var knockback_force: float = 100

func _on_collision_entered(_body: Node) -> void:
	if _body is Player:
		
		# Knockback
		var knockback_dir = get_direction_raycast()

		_body.velocity += knockback_dir * knockback_force

		# Stun the player
		_body.stateManager.request_state("Stun")
