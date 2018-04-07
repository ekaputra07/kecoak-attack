extends CanvasLayer

signal start_game
signal goto_home

var score = 0
var best = 0

func _ready():
	set_score()

func set_score():
	$Score.text = str("Score: ", score)
	$Best.text = str("Best: ", best)

func _on_Start_pressed():
	emit_signal("start_game")
	queue_free()

func _on_Home_pressed():
	emit_signal("goto_home")
	queue_free()
