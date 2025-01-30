extends StaticBody2D
class_name Obstacle

@export var distance_ray = 32

var direction_raycast: Vector2 = Vector2(0, 0)
var collision_ray = RayCast2D.new()

var objects_colliding: Array = []
var old_objects_colliding: Array = []

func _ready() -> void:
	add_child(collision_ray)
	collision_ray.force_raycast_update()
	collision_ray.enabled = true
	collision_ray.exclude_parent = true

func _physics_process(_delta: float) -> void:
	direction_raycast = get_direction_raycast()

	# Cast a ray in the direction of the obstacle
	collision_ray.target_position = direction_raycast * distance_ray



	if collision_ray.is_colliding() && collision_ray.get_collider() != self:
		collision_ray.force_raycast_update()
		objects_colliding.append(collision_ray.get_collider())

	for obj in old_objects_colliding:
		if not objects_colliding.has(obj):
			_on_collision_exited(obj)
	
	for obj in objects_colliding:
		if not old_objects_colliding.has(obj):
			_on_collision_entered(obj)

	old_objects_colliding.clear()
	
	for obj in objects_colliding:
		old_objects_colliding.append(obj)

	objects_colliding.clear()



func get_direction_raycast() -> Vector2:
	match WorldDirection.direction:
		WorldDirection.Direction.UP: return Vector2(0, -1)
		WorldDirection.Direction.DOWN: return Vector2(0, 1)
		WorldDirection.Direction.LEFT: return Vector2(1, 0) 
		WorldDirection.Direction.RIGHT: return Vector2(-1, 0)
		_ : return Vector2(0, -1)

func _on_collision_entered(_body: Node) -> void:
	push_error("Obstacle._on_collision_entered() not implemented")

func _on_collision_exited(_body: Node) -> void:
	push_error("Obstacle._on_collision_exited() not implemented")
