extends CanvasLayer

signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)

var db            : SQLite
var current_score : int = 0
var high_score    : int = 0

@onready var score_label      : Label = $ScoreLabel
@onready var high_score_label : Label = $HighScoreLabel

func _ready() -> void:
	# 1) Open (or create) the database
	db = SQLite.new()
	db.path = "user://data.db"
	if not db.open_db():
		push_error("❌ Could not open %s" % db.path)
		return
	var abs_path = ProjectSettings.globalize_path(db.path)
	print("DB ligger her: ", abs_path)

	# 2) Ensure our table exists
	db.create_table("scores", {
		"key":   {"data_type":"text", "primary_key":true},
		"value": {"data_type":"int"}
	})

	# 3) Load any saved high score
	var rows = db.select_rows("scores", "key='high_score'", ["value"])
	if rows.size() > 0:
		high_score = int(rows[0]["value"])
	else:
		high_score = 0
	_update_high_score_label(high_score)

	# 4) Initialize current score = 0
	_update_score_label(current_score)

func add_score(points: int) -> void:
	current_score += points
	_update_score_label(current_score)
	emit_signal("score_changed", current_score)

	if current_score > high_score:
		high_score = current_score
		_update_high_score_label(high_score)
		emit_signal("high_score_changed", high_score)

		# 5) Upsert via SQL INSERT OR REPLACE
		var sql = "INSERT OR REPLACE INTO scores (key, value) VALUES ('high_score', %d);" % high_score
		if not db.query(sql):
			push_error("❌ Kunne ikke gemme high_score (%d)" % high_score)
		else:
			print("✅ New high_score saved:", high_score)

func reset_score() -> void:
	current_score = 0
	_update_score_label(current_score)
	emit_signal("score_changed", current_score)

func _update_score_label(scr: int) -> void:
	score_label.text = "Score: %d" % scr

func _update_high_score_label(hs: int) -> void:
	high_score_label.text = "High Score: %d" % hs
