extends RichTextLabel

var defaultText = text
var startedAt
const animationSpeed = 1
const animationDelay = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startedAt = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var coef = (Time.get_unix_time_from_system()-(startedAt+animationDelay))/animationSpeed
	if coef<0:coef=0
	elif coef>1:coef=1
	text = defaultText + str(int(coef*Score.score))
