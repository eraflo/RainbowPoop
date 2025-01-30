extends ProgressBar

const HealthSystem = preload("res://Assets/Scripts/HealthSystem/HealthSystem.gd")

@onready var health_system: HealthSystem = $HealthSystem

func _ready():
	health_system.health_status_changed.connect(_on_health_status_changed)
	health_system.imc_changed.connect(_on_imc_changed)

	# TODO: improve the way to set the min and max values
	max_value = health_system.health_thresholds[HealthSystem.HealthStatus.OBESE]
	min_value = health_system.health_thresholds[HealthSystem.HealthStatus.SEVERELY_UNDERWEIGHT]


# TODO: Change the color of the health bar based on the health status
func _on_health_status_changed(_healthStatus: HealthSystem.HealthStatus):
	pass

func _on_imc_changed(_imc: float):
	print("IMC changed to: ", _imc)
	value = _imc
