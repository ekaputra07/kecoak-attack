extends CanvasLayer

signal start_game
signal goto_home

var score = 0
var best = 0
var game_data

func _ready():
	game_data = Utils.load_game_data()
	best = game_data["best_score"]
	
	set_score()

func set_score():
	$Overlay/GameOver.text = "GAME OVER!"
	$Overlay/Score.text = str("SCORE ", score)
	
	if score > best:
		persist_score(score)
	
	if best > 0:
		if score >= best:
			$Overlay/Best.text = str("BEST ", score)
		else:
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
	Utils.goto_scene("res://scenes/Home.tscn")

func persist_score(score):
	game_data["best_score"] = score
	Utils.save_game_data(game_data)