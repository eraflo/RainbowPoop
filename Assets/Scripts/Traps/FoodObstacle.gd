extends Obstacle

@export var knockback_force: float = 100

func _on_collision_entered(_body: Node) -> void:
	if _body is Player:
		
		# Knockback
		var knockback_dir = (_body.global_position - global_position).normalized()

		_body.velocity = knockback_dir * knockback_force

		# Stun the player
		_body.stateManager.request_state("Stun")

func _on_collision_exited(_body: Node) -> void:
	pass
