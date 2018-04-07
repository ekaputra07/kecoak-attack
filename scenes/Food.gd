extends StaticBody2D

signal finish
signal contamination_updated

export var MIN_CONTAMINATION = 0
export var MAX_CONTAMINATION = 100
var contamination = MIN_CONTAMINATION
var animated_contamination = MIN_CONTAMINATION

func _ready():
	if not $Tween.is_active():
		$Tween.start()

func _process(delta):
	var rounded_contamination = round(animated_contamination)
	$Progress.value = rounded_contamination

func eated(energy):
	if contamination >= MAX_CONTAMINATION:
		return
		
	print(str("contaminated: ", energy))
	
	contamination += energy
	emit_signal("contamination_updated", contamination)
	$Tween.interpolate_property(self, "animated_contamination", animated_contamination, contamination, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	if contamination >= MAX_CONTAMINATION:
		emit_signal("finish")
		queue_free()