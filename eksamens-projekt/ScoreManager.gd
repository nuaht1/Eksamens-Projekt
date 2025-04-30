extends Node

const SQLite = preload("res://addons/godot-sqlite/godot-sqlite.gd")

signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)

var db
var current_score: int = 0
var high_score:   int = 0

func _ready() -> void:
	# open (or create) the database file
	db = SQLite.new()
	db.open("user://highscores.db")

	# create table if missing
	db.query("CREATE TABLE IF NOT EXISTS scores(key TEXT PRIMARY KEY, value INTEGER);")

	# load high score
	var rows = db.query("SELECT value FROM scores WHERE key = 'high_score';")
	high_score = rows.size() > 0 ? int(rows[0]["value"]) : 0
	emit_signal("high_score_changed", high_score)

func add_score(points: int) -> void:
	current_score += points
	emit_signal("score_changed", current_score)

	if current_score > high_score:
		high_score = current_score
		emit_signal("high_score_changed", high_score)
		db.query("INSERT OR REPLACE INTO scores(key, value) VALUES('high_score', %d);" % high_score)

func reset_score() -> void:
	current_score = 0
	emit_signal("score_changed", current_score)
