extends Collectable

const Player = preload("res://Assets/Scripts/Player.gd")

@export var decrease_speed: float = 100

@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape2D

var _cooldown_before_speed_back: float = 0.5
var _cooldown_timer: Timer = null

var _collector: Player = null

func _ready() -> void:
	super._ready()
	_cooldown_timer = Timer.new()
	add_child(_cooldown_timer)
	_cooldown_timer.set_wait_time(_cooldown_before_speed_back)
	_cooldown_timer.set_one_shot(true)
	_cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		Score.decrement_score(score)
		body.max_speed.add_modifier(StatModifier.new(
			-decrease_speed,
			StatModifier.StatModType.Flat,
			100,
			self
		))

		# Save the player to give back the speed after a cooldown
		_collector = body
		_cooldown_timer.start()

		# Hide sprite
		sprite.visible = false

		# Deactivate collision
		collision_shape.disabled = true

	pass

func _on_cooldown_timer_timeout() -> void:

	if _collector != null:
		_collector.max_speed.remove_all_modifiers_from_source(self)
		_collector = null
		queue_free()
	pass
