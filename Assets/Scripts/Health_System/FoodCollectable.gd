extends Collectable

const Player = preload("res://Assets/Scripts/Player.gd")

@export var food: Food = null

@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	super._ready()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.eat_food(food)
		queue_free()

	pass
