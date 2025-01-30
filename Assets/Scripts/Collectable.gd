extends Area2D
class_name Collectable
"""
Objects that can be collected.

A base class for collectible items in the game.
Handles basic collection behavior and scoring.

Properties:
	score (float): The score value awarded when collected
"""

@export var score: float = 0

var trigger_area: Area2D

func _ready() -> void:
	add_to_group("collectable")
	trigger_area = self
	trigger_area.connect("body_entered", _on_body_entered)


## Called when a physics body enters this collectable's area.
## Implement this in derived classes to define collection behavior.
## [br]
## [param _body] The node that entered the collection area
func _on_body_entered(_body: Node) -> void:
	push_error("Collectable._on_body_entered() not implemented")
