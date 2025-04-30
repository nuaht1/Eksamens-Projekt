extends Node

# signal declarations
signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)

var current_score: int = 0
var high_score:    int = 0

func _ready() -> void:
	_load_high_score()
	emit_signal("high_score_changed", high_score)

func add_score(points: int) -> void:
	current_score += points
	emit_signal("score_changed", current_score)
	if current_score > high_score:
		high_score = current_score
		emit_signal("high_score_changed", high_score)
		_save_high_score()

func reset_score() -> void:
	current_score = 0
	emit_signal("score_changed", current_score)

# ————————————————
# Persistence helpers
# ————————————————

func _save_high_score() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("scores", "high_score", high_score)
	var err := cfg.save("user://game_data.cfg")
	if err != OK:
		push_error("Failed saving high score: %s" % err)

func _load_high_score() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://game_data.cfg") == OK:
		# get_value(section, key, default)
		high_score = int(cfg.get_value("scores", "high_score", 0))
	else:
		high_score = 0
