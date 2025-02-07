extends Area2D

const Player = preload("res://Assets/Scripts/Player.gd")

@export var stat_to_reset: String = "weight"

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        match stat_to_reset:
            "weight":
                body.weight.remove_all_modifiers()
            "height":
                body.height.remove_all_modifiers()
            "max_speed":
                body.max_speed.remove_all_modifiers()
            "jump_force":
                body.jump_force.remove_all_modifiers()
            "jump_delay":
                body.jump_delay.remove_all_modifiers()
            "friction":
                body.friction.remove_all_modifiers()
            "falling_speed":
                body.falling_speed.remove_all_modifiers()
            "bounce_factor":
                body.bounce_factor.remove_all_modifiers()
            "stun_duration":
                body.stun_duration.remove_all_modifiers()

