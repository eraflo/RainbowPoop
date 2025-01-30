extends StaticBody2D
class_name Obstacle

@export var distance_ray = 32

var direction_raycast: Vector2 = Vector2(0, 0)
var collision_ray = RayCast2D.new()



func _physics_process(_delta: float) -> void:
	direction_raycast = get_direction_raycast()

	# Cast a ray in the direction of the obstacle
	collision_ray.target_position = direction_raycast * distance_ray
	
	print(collision_ray.is_colliding())

	if collision_ray.is_colliding():
		collision_ray.force_raycast_update()
		_on_collision_entered(collision_ray.get_collider())


func get_direction_raycast() -> Vector2:
	match WorldDirection.direction:
		WorldDirection.Direction.UP: return Vector2(0, -1)
		WorldDirection.Direction.DOWN: return Vector2(0, 1)
		WorldDirection.Direction.LEFT: return Vector2(-1, 0)
		WorldDirection.Direction.RIGHT: return Vector2(1, 0)
		_ : return Vector2(0, -1)

func _on_collision_entered(_body: Node) -> void:
	push_error("Obstacle._on_collision_entered() not implemented")
