extends Node

# Connects to the ScoreCounter script to receive score updates
signal score_changed(score: float)

const TIME_MULTIPLIER: int = 10
const HEALTHY_MULTIPLIER: int = 100

@export var score: float = 0


func _ready() -> void:
	score = 0


func _process(delta: float) -> void:
	increment_score(TIME_MULTIPLIER * delta)
	#print("Score: ", score)


# Use that one to increment the score
func increment_score(amount: float) -> void:
	score += amount
	score_changed.emit(score)

# Use that one to decrement the score
func decrement_score(amount: float) -> void:
	score -= amount
	score_changed.emit(score)
