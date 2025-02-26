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
		AudioManager.createAudioAtLocation(self.position, AudioEffectSettings.AudioEffectType.ON_FOOD_COLLECTED)
		queue_free()

	pass
