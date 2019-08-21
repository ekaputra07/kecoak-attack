extends StaticBody2D

signal finish
signal contamination_updated

export var MIN_CONTAMINATION = 0
export var MAX_CONTAMINATION = 100
var contamination = MIN_CONTAMINATION
var animated_contamination = MIN_CONTAMINATION

func _process(delta):
	var rounded_contamination = round(animated_contamination)
	$Progress.value = rounded_contamination

func reset_contamination():
	contamination = MIN_CONTAMINATION
	animated_contamination = MIN_CONTAMINATION

func eated(energy):
	print(str("contaminated: ", energy))
	
	contamination += energy
	emit_signal("contamination_updated", contamination)
	$Tween.interpolate_property(self, "animated_contamination", animated_contamination, contamination, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	if contamination >= MAX_CONTAMINATION:
		emit_signal("finish")
		queue_free()