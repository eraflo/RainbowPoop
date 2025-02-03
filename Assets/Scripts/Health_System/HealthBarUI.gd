extends ProgressBar


func _ready():
	Health.health_status_changed.connect(_on_health_status_changed)
	Health.imc_changed.connect(_on_imc_changed)

	# TODO: improve the way to set the min and max values
	max_value = Health.health_thresholds[Health.HealthStatus.OBESE]
	min_value = Health.health_thresholds[Health.HealthStatus.SEVERELY_UNDERWEIGHT]


# TODO: Change the color of the health bar based on the health status
func _on_health_status_changed(_healthStatus: Health.HealthStatus):
	pass

func _on_imc_changed(_imc: float):
	# print("IMC changed to: ", _imc)
	value = _imc
