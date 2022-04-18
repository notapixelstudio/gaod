extends Area2D
class_name Tile

export var outline_shader: Resource
const WIDTH := 86
var width := WIDTH

onready var sprite = $Sprite

func _ready():
	Events.connect('card_picked', self, '_on_card_picked')
	Events.connect('card_dropped', self, '_on_card_dropped')
	Events.connect('card_destroyed', self, '_on_card_destroyed')

# BUSINESS LOGIC
func interact(card):
	if not self.is_valid_target(card):
		return
		
	match card.title:
		'KILL':
			queue_free()
			return true
		'GROW':
			scale = Vector2(2,2)
			return true
	
	return false
	
func is_valid_target(card):
	return card.title in ['KILL', 'GROW']

# HOVER
func hover(card):
	if not self.is_valid_target(card):
		return
	
	focus()
	
func _on_Target_area_shape_exited(area_id, area, area_shape, self_shape):
	blur()
	
# HINT
func _on_card_picked(card):
	if not self.is_valid_target(card):
		return
		
	self.highlight()
	
func _on_card_dropped(card):
	self.remove_highlight()
	
func _on_card_destroyed(card):
	self.remove_highlight()
	

func highlight():
	sprite.set_material(outline_shader)
	
func remove_highlight():
	sprite.material = null
	
func focus():
	outline_shader.set_shader_param('outline_color', Color('#ffcc00'))
	outline_shader.set_shader_param('width', 6)

func blur():
	outline_shader.set_shader_param('outline_color', Color('#ff6c00'))
	outline_shader.set_shader_param('width', 4)
	
###
# AUTOMATIC MOVEMENT
###

onready var position_tween = $PositionTween

func gracefully_go_to(point):
	position_tween.interpolate_property(self, 'position',
		position, point, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	position_tween.start()
	
