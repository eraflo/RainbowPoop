extends Node

const ScoreCounter = preload("res://Assets/Scripts/Score/ScoreCounter.gd")

@onready var score_system: ScoreCounter = $Score
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	score_system.connect("score_changed", _on_score_changed)

func _on_score_changed(score: float) -> void:
	score_label.text = str(score)
