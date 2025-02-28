extends RichTextLabel

var score: int = 0

var defaultText = text
var startedAt
const animationSpeed = 1
const animationDelay = 2

signal update_score_display(score: int, coef: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startedAt = Time.get_unix_time_from_system()
	score = Score.score

	update_score_display.connect(_on_update_score_display)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var coef = (Time.get_unix_time_from_system()-(startedAt+animationDelay))/animationSpeed
	if coef<0:
		coef=0
	elif coef>=1:
		coef=1
	else:
		update_score_display.emit(score, coef)
	

	if coef>=1:
		score = 0
		pass

func _on_update_score_display(score: int, coef: float) -> void:
	text = defaultText + str(int(coef*score))
