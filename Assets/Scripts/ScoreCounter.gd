extends Node

signal score_changed(score: float)

const TIME_MULTIPLIER: int = 10
const HEALTHY_MULTIPLIER: int = 100

var score: float = 0


func _ready() -> void:
	score = 0


func _process(delta: float) -> void:
	increment_score(TIME_MULTIPLIER * delta)
	print("Score: ", score)


func increment_score(amount: float) -> void:
	score += amount
	emit_signal("score_changed", score)
	
