extends Node
class_name HealthSystem

enum HealthStatus 
{
	SEVERELY_UNDERWEIGHT,
	UNDERWEIGHT,
	NORMAL,
	OVERWEIGHT,
	OBESE
}

signal health_status_changed(status: HealthStatus)
signal imc_changed(imc: float)

const health_thresholds: Dictionary = {
	HealthStatus.SEVERELY_UNDERWEIGHT: 16.5,
	HealthStatus.UNDERWEIGHT: 18.5,
	HealthStatus.NORMAL: 25.0,
	HealthStatus.OVERWEIGHT: 30.0,
	HealthStatus.OBESE: 35.0
}

# TODO: Decide on the weight change values
const health_weight_change: Dictionary = {
	HealthStatus.SEVERELY_UNDERWEIGHT: 0.2,
	HealthStatus.UNDERWEIGHT: 0.1,
	HealthStatus.NORMAL: 0.0,
	HealthStatus.OVERWEIGHT: -0.1,
	HealthStatus.OBESE: -0.2
}

const MIN_IMC = 0.0
const MAX_IMC = 50.0

var health_status: HealthStatus = HealthStatus.NORMAL

var weight: float = 0.0
var height: float = 0.0


var imc: float = 0.0

func _ready() -> void:
	_calculate_imc()

func _process(_delta: float) -> void:
	# Lose weight over time
	weight -= health_weight_change[health_status] * _delta
	# print("Weight: ", weight)
	# print("Health Status: ", health_status)
	# print("Health Weight Change: ", health_weight_change[health_status])

	_calculate_imc()

func _calculate_imc() -> void:
	# Calculate the IMC
	imc = weight / (height * height)

	# Round the IMC to 2 decimal places
	imc = round(imc * 100) / 100

	# Clamp the IMC to the min and max values
	imc = clamp(imc, MIN_IMC, MAX_IMC)

	# Emit the IMC changed signal
	imc_changed.emit(imc)
	_calculate_health_status()

func _calculate_health_status() -> void:
	for status in health_thresholds.keys():
		if imc < health_thresholds[status]:
			health_status = status
			health_status_changed.emit(health_status)
			break
