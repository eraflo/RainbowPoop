extends Area2D

const Player = preload("res://Assets/Scripts/Player.gd")

enum StatToReset {
    weight,
    height,
    max_speed,
    jump_force,
    jump_delay,
    friction,
    falling_speed,
    bounce_factor,
    stun_duration
}

@export var stat_to_reset: StatToReset = StatToReset.weight

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        match stat_to_reset:
            StatToReset.weight:
                body.weight.remove_all_modifiers()
            StatToReset.height:
                body.height.remove_all_modifiers()
            StatToReset.max_speed:
                body.max_speed.remove_all_modifiers()
            StatToReset.jump_force:
                body.jump_force.remove_all_modifiers()
            StatToReset.jump_delay:
                body.jump_delay.remove_all_modifiers()
            StatToReset.friction:
                body.friction.remove_all_modifiers()
            StatToReset.falling_speed:
                body.falling_speed.remove_all_modifiers()
            StatToReset.bounce_factor:
                body.bounce_factor.remove_all_modifiers()
            StatToReset.stun_duration:
                body.stun_duration.remove_all_modifiers()

