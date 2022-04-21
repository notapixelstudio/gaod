extends Area2D
class_name Tile

export var outline_shader: Resource
const WIDTH := 88
var width := WIDTH

var title := 'empty' setget set_title

func set_title(v):
	title = v
	if v == 'empty':
		$Label.text = ''
		$Content.texture = null
	else:
		$Label.text = v
		$Content.texture = load('res://assets/cards/'+title.to_lower()+'.png')
	
func activate(mortal):
	yield(get_tree().create_timer(0.5), "timeout")
	match title:
		'empty':
			mortal.set_direction_forward()
			Events.emit_signal("mortal_turn_end")
		'bananas':
			self.set_title('banana')
			Events.emit_signal("mortal_about_to_move", mortal.get_steps())
		'banana':
			self.set_title('empty')
			Events.emit_signal("mortal_about_to_move", mortal.get_steps())
		'demon dice':
			mortal.set_direction_forward()
			Events.emit_signal("mortal_turn_start")
		'springs':
			self.set_title('spring')
			mortal.flip_direction()
			Events.emit_signal("mortal_about_to_move", mortal.get_steps())
		'spring':
			self.set_title('empty')
			mortal.flip_direction()
			Events.emit_signal("mortal_about_to_move", mortal.get_steps())
		'angel dice':
			mortal.set_direction_backwards()
			Events.emit_signal("mortal_turn_start")
	
###
# AUTOMATIC MOVEMENT
###

onready var position_tween = $PositionTween

func gracefully_go_to(point):
	position_tween.interpolate_property(self, 'position',
		position, point, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	position_tween.start()
	
