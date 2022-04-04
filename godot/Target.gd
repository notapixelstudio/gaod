extends Area2D

export var outline_shader: Resource
onready var sprite = $Sprite
 
func interact(card):
	if card.title == 'KILL':
		queue_free()
		return true
	
	return false


func _on_Target_mouse_entered():
	sprite.set_material(outline_shader)


func _on_Target_mouse_exited():
	sprite.material = null

func _on_Target_area_shape_entered(area_id, area, area_shape, self_shape):
	sprite.set_material(outline_shader)


func _on_Target_area_shape_exited(area_id, area, area_shape, self_shape):
	sprite.material = null
