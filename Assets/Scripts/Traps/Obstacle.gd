extends StaticBody2D
class_name Obstacle


const Player = preload("res://Assets/Scripts/Player.gd")

var player: Player

var is_colliding: bool = false

func _ready() -> void:
	player = ObstacleManager.player
	player.got_collision.connect(_on_player_collision)

func _on_player_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider() == self and not is_colliding:
		is_colliding = true
		_on_collision_entered(player)
	elif collision.get_collider() != self and is_colliding:
		is_colliding = false
		_on_collision_exited(player)

func _on_collision_entered(_body: Node) -> void:
	push_error("Obstacle._on_collision_entered() not implemented")

func _on_collision_exited(_body: Node) -> void:
	push_error("Obstacle._on_collision_exited() not implemented")
