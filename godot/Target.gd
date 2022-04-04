extends Area2D

export var outline_shader: Resource
onready var sprite = $Sprite
 
func interact(card):
	if card.title == 'KILL':
		queue_free()
		return true
	
	return false


func hover(card):
	# TBD some cards are different about this
	if card.title == 'KILL':
		self.highlight()
	
func _on_Target_area_shape_exited(area_id, area, area_shape, self_shape):
	self.remove_highlight()
	
	
func highlight():
	sprite.set_material(outline_shader)

func remove_highlight():
	sprite.material = null
	
