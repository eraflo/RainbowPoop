extends Node

# Connects to the ScoreCounter script to receive score updates
signal score_changed(score: float)

const TIME_MULTIPLIER: int = 100

@export var score: float = 0

var _start_counting: bool = false
var _time: float = 0
var _bonus_score: float = 0

var current_countdown: float = 0

func _process(delta: float) -> void:
	if _start_counting:
		_time += delta

		# TODO: remove later
		calculate_time_score()
	#print("Score: ", score)

# Reset the score to 0
func reset() -> void:
	score = 0
	current_countdown = 0
	_start_counting = true

# Stop the score from incrementing
func stop_counting() -> void:
	_start_counting = false

# Use that one to increment the score
func increment_score(amount: float) -> void:
	_bonus_score += amount

# Use that one to decrement the score
func decrement_score(amount: float) -> void:
	_bonus_score -= amount

func calculate_health_score() -> void:
	# Formula : (IMC * HEALTH_STATUS_MULTIPLIER) + HEALTH_STATUS_ADDITION
	score *= Health.health_status_score_multiplier[Health.health_status]
	score += Health.health_status_score_addition[Health.health_status]
	score_changed.emit(score)

func calculate_time_score() -> void:

	# Formula : (level timer for good score - time spent to complete the level) * TIME_MULTIPLIER
	score = round((current_countdown - _time) * TIME_MULTIPLIER)
	score += _bonus_score
	score = max(0, score)

	score_changed.emit(score)
