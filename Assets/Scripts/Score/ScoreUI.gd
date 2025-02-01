extends Node

@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	Score.connect("score_changed", _on_score_changed)	

func _on_score_changed(score: float) -> void:
	score_label.text = str(score)


		
