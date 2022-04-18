extends Area2D
class_name Tile

export var outline_shader: Resource
const WIDTH := 88
var width := WIDTH

###
# AUTOMATIC MOVEMENT
###

onready var position_tween = $PositionTween

func gracefully_go_to(point):
	position_tween.interpolate_property(self, 'position',
		position, point, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	position_tween.start()
	
