extends ProgressBar

var indicator: TextureRect
var indicatorStartPosition: Vector2

func _ready():
	Health.health_status_changed.connect(_on_health_status_changed)
	Health.imc_changed.connect(_on_imc_changed)

	# TODO: improve the way to set the min and max values
	max_value = Health.health_thresholds[Health.HealthStatus.OBESE]
	min_value = 0.0

	# Position the indicator
	indicator = get_parent().get_node("Indicator") as TextureRect
	indicatorStartPosition = indicator.position

func _exit_tree():
	Health.health_status_changed.disconnect(_on_health_status_changed)
	Health.imc_changed.disconnect(_on_imc_changed)

func _change_indicator_position(_value: float):
	indicator.position = indicatorStartPosition

	indicator.position.x += (_value - min_value) / (max_value - min_value) * get_rect().size.x

# TODO: Change the color of the health bar based on the health status
func _on_health_status_changed(_healthStatus: Health.HealthStatus):
	pass

func _on_imc_changed(_imc: float):
	value = _imc
	_change_indicator_position(value)
