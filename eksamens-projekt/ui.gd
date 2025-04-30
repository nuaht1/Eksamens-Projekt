# UI.gd, attached to your CanvasLayer named “UI”

extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var high_label  = $HighScoreLabel

func _ready() -> void:
	ScoreManager.connect("score_changed",       Callable(self, "_on_score_changed"))
	ScoreManager.connect("high_score_changed", Callable(self, "_on_high_score_changed"))
	_on_score_changed( ScoreManager.current_score )
	_on_high_score_changed( ScoreManager.high_score )

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_high_score_changed(new_high: int) -> void:
	high_label.text = "High Score: %d" % new_high
