extends Area2D

"""
Draggable card. Fires 'picked' at drag start and 'dropped' at drag end.
Appearance and effect are both defined by a single 'title' string.
"""

###
# CARD DEFINITION
###

var title setget set_title
onready var label = $Label

func set_title(v):
	title = v
	label.text = v

###
# DRAG AND DROP
###

signal picked
signal dropped

var previous_mouse_position = Vector2()
var dragging = false setget set_dragging

func set_dragging(v):
	dragging = v
	
	z_index = int(dragging) # set z-index to one while dragging, to keep the card above others

func _on_Card_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_touch'):
		# Start dragging
		get_tree().set_input_as_handled()
		previous_mouse_position = event.position
		set_dragging(true)
		set_hovering(false)
		emit_signal('picked', self)

func _input(event):
	if not dragging:
		return
		
	if event is InputEventMouseMotion:
		# Continue dragging
		# update position relative to the picked point
		position += event.position - previous_mouse_position
		previous_mouse_position = event.position
	
	if event.is_action_released('ui_touch'):
		# End dragging
		previous_mouse_position = Vector2()
		set_dragging(false)
		
		# Check if dropped onto target
		for area in get_overlapping_areas():
			if area.is_in_group('targets'):
				var interacted = area.interact(self)
				if interacted:
					queue_free() # cards are single use
				
		emit_signal('dropped', self)
	
###
# AUTOMATIC MOVEMENT
###

onready var position_tween = $PositionTween

func gracefully_go_to(point):
	position_tween.interpolate_property(self, 'position',
		position, point, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	position_tween.start()
	
###
# HOVER
###

onready var scale_tween = $ScaleTween
var hovering = false setget set_hovering

func set_hovering(v):
	hovering = v
	
	var target_scale
	if hovering:
		target_scale = 1.3*Vector2(1,1)
	else:
		target_scale = Vector2(1,1)
	
	scale_tween.interpolate_property(self, 'scale',
		scale, target_scale, 0.25,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	scale_tween.start()

func _on_Card_mouse_entered():
	set_hovering(true)
	
func _on_Card_mouse_exited():
	set_hovering(false)
