extends Area2D

signal eating
signal finish_eating
signal dead

export var speed = 200
export var energy = 10

onready var Target = get_node("../Food")
onready var EatingLocation = get_node("../Food/EatingPath/EatingLocation");

enum status {MOVING, STOP, DEAD}
var current_status = MOVING

var velocity = Vector2()
var eating_location = Vector2()

func _ready():
	$AnimatedSprite.animation = "walk"
	$AnimatedSprite.play()
	
	if not $Tween.is_active():
		$Tween.start()
	
	# set head angle to random eating path/location (to make it looks more realistic).
	EatingLocation.set_offset(randi())
	eating_location = Vector2(EatingLocation.global_position.x, Target.position.y)
	
	var angle = position.angle_to_point(eating_location)
	rotation = angle - PI/2
	
func _process(delta):
	if current_status == MOVING:
		velocity = Vector2(eating_location - position).normalized() * speed
		position += velocity * delta

func _on_Kecoak_body_entered(body):
	if body.name == "Food":
		current_status = STOP
		$AnimatedSprite.animation = "stop"
		emit_signal("eating", energy)
		$EatingTimer.start()

func _on_Kecoak_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and current_status == MOVING:
		current_status = DEAD
		$AnimatedSprite.animation = "dead"
		emit_signal("dead")
		fade_out(3.0)

func _on_EatingTimer_timeout():
	# when finished eating we fadeout the body.
	fade_out(3.0)
	
func _on_Tween_tween_completed(object, key):
	# once body faded out, free resource.
	if object is Area2D and key == ":modulate":
		
		if current_status == STOP:
			emit_signal("finish_eating", energy)
			
		queue_free()

func fade_out(duration):
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	$Tween.interpolate_property(self, "modulate", start_color, end_color, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)