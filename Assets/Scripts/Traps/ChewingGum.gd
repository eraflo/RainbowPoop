extends Obstacle

@export var frictionAdded: float = 0.5

func _on_collision_entered(_body: Node) -> void:
	print(_body)
	if _body is Player:

		# Play sound
		AudioManager.createAudio(AudioEffectSettings.AudioEffectType.ON_TRAP_ACTIVATED)
		
		# Add friction to the player
		_body._add_modifier(_body.friction, frictionAdded, StatModifier.StatModType.Flat, 100, self)

func _on_collision_exited(_body: Node) -> void:
	if _body is Player:
		# Remove friction from the player
		_body.friction.remove_all_modifiers_from_source(self)
