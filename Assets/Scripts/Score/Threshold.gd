extends Node


var current_threshold: Threshold = Threshold.LOW

enum Threshold {
	LOW = 0,
	MEDIUM = 100,
	HIGH = 200
}

func get_threshold(score: float) -> Threshold:
	if score < Threshold.MEDIUM:
		return Threshold.LOW
	elif score < Threshold.HIGH:
		return Threshold.MEDIUM
	else:
		return Threshold.HIGH

func get_threshold_string(threshold: Threshold) -> String:
	match threshold:
		Threshold.LOW:
			return "Low"
		Threshold.MEDIUM:
			return "Medium"
		Threshold.HIGH:
			return "High"
		_:
			return "Unknown"
			
			
func _on_score_changed(score: float) -> void:
	var new_threshold = get_threshold(score)
	if new_threshold != current_threshold:
		current_threshold = new_threshold
		print("Threshold changed to: ", get_threshold_string(current_threshold))
