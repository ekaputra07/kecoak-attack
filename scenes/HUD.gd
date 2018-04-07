extends CanvasLayer

signal start_game
signal goto_home

var score = 0
var best = 0

func _ready():
	set_score()

func set_score():
	if score > best and best > 0:
		$Overlay/GameOver.text = "BEST SCORE!"
	else:
		$Overlay/GameOver.text = "GAME OVER!"

	$Overlay/Score.text = str("SCORE ", score)
	
	if best > 0:
		$Overlay/Best.text = str("BEST ", best)
		$Overlay/Best.show()
	else:
		$Overlay/Best.hide()

func _on_StartBtn_pressed():
	emit_signal("start_game")
	queue_free()

func _on_HomeBtn_pressed():
	emit_signal("goto_home")
	queue_free()
