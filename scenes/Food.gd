extends StaticBody2D

signal finish
signal health_updated

export var MAX_HEALTH = 100
var health = MAX_HEALTH

func eated(energy):
	if health <= 0:
		return
		
	print(str("Eated: ", energy))
	
	health -= energy
	emit_signal("health_updated", health)
	
	if health <= 0:
		emit_signal("finish")
		queue_free()