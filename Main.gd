extends Node

signal speed_up
signal score_updated

export (PackedScene) var Food
export (PackedScene) var Cockroach
export (PackedScene) var HUD

export var INITIAL_SPEED = 200
export var ACCELERATION = 100
export var ACCELERATION_OFFSET = 5

var score = 0
var acceleration_multiplier = 0

func _ready():
	randomize()
	start_game()

func _on_Timer_timeout():
	spawn_cockroach()

func spawn_cockroach():
	# set spawn location offset to random location.
	$SpawnPath/SpawnLocation.set_offset(randi())
	
	var cockr = Cockroach.instance()
	var speed = INITIAL_SPEED + (ACCELERATION * acceleration_multiplier)
	#print(str("Speed: ", speed))
	cockr.speed = speed
	cockr.position = $SpawnPath/SpawnLocation.position
	cockr.connect("dead", self, "on_Cockroach_dead")
	cockr.connect("eating", self, "on_Cockroach_eating")
	add_child(cockr)
	
func show_HUD():
	var hud = HUD.instance()
	hud.score = score
	hud.connect("start_game", self, "start_game")
	add_child(hud)

func start_game():
	# reset values
	score = 0
	acceleration_multiplier = 0
	
	# reset score UI
	update_score(score)
	
	# add Food
	var food = Food.instance()
	food.connect("finish", self, "on_Food_finish")
	food.connect("contamination_updated", self, "on_Food_contamination_updated")
	add_child(food)
	
	# start spawn timer
	$SpawnTimer.start()

# -----------Cockreach Signals ------------------ #
func on_Cockroach_dead():
	score += 1
	
	# increase the acceleration based on score.
	# don't increment acceleration_multiplier if its still 0 (player still in initial speed)
	if (score % ACCELERATION_OFFSET) == 0:
		acceleration_multiplier += 1
		emit_signal("speed_up")

	update_score(score)
	
func on_Cockroach_eating(energy):
	$Food.eated(energy)
	
func update_score(score):
	emit_signal("score_updated", score)
	$TopPanel/ScoreLabel.text = str("SCORE ", score)

# -----------Food Signals ------------------ #
func on_Food_contamination_updated(contamination):
	print(str("Food contamination: ", contamination))

func on_Food_finish():
	print("GAME OVER!!!")
	# stop spawning
	$SpawnTimer.stop()
	
	show_HUD()
		
	# remove all cockroaches that left.
	for cockr in get_tree().get_nodes_in_group("cockroaches"):
		cockr.fade_out(1.0)