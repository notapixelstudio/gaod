extends Area2D

class_name Card

"""
Draggable card. Fires 'picked' at drag start and 'dropped' at drag end.
Appearance and effect are both defined by a single 'title' string.
"""

export var front_texture : Texture
export var back_texture : Texture

export var enabled := true setget set_enabled

func _ready():
	set_face_down()
	
	Events.connect('card_picked', self, '_on_card_picked')
	Events.connect('card_dropped', self, '_on_card_dropped')
	Events.connect('card_destroyed', self, '_on_card_destroyed')
	
func set_face_up():
	$Sprite.texture = front_texture
	
func set_face_down():
	$Sprite.texture = back_texture

###
# CARD DEFINITION
###

var title setget set_title

func set_title(v):
	title = v
	if v == 'empty':
		$Label.text = ''
		$Content.texture = null
	else:
		$Label.text = v
		$Content.texture = load('res://assets/cards/'+title.to_lower()+'.png')
		
	match title:
		'empty':
			$Description.text = ''
		'ghost tile':
			$Description.text = 'Danger: not solid'
			front_texture = load('res://assets/blocks/ghost.png')
		'rewind':
			$Description.text = 'Go one step backwards, then flips'
		'forward':
			$Description.text = 'Go one step forward, then flips'
		'bananas':
			$Description.text = 'Continue moving, same amount'
		'banana':
			$Description.text = 'Continue moving, same amount'
		'demon dice':
			$Description.text = 'Roll again, move forward'
		'demon die':
			$Description.text = 'Roll again, move forward'
		'springs':
			$Description.text = 'Go back where you came from'
		'spring':
			$Description.text = 'Go back where you came from'
		'angel dice':
			$Description.text = 'Roll again, move backwards'
		'angel die':
			$Description.text = 'Roll again, move backwards'
		'lightbulbs':
			$Description.text = 'Draw to 3 cards'
		'lightbulb':
			$Description.text = 'Draw to 3 cards'

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
	if not enabled:
		return
		
	if event.is_action_pressed('ui_touch'):
		# Start dragging
		get_tree().set_input_as_handled()
		previous_mouse_position = event.position
		set_dragging(true)
		set_hovering(false)
		self.shrink_area()
		emit_signal('picked', self)
		Events.emit_signal("card_picked", self)

func _input(event):
	if not enabled or not dragging:
		return
		
	if event is InputEventMouseMotion:
		# Continue dragging
		# update position relative to the picked point
		position += event.position - previous_mouse_position
		previous_mouse_position = event.position
		
		# Check if hovering on target
		for area in get_overlapping_areas():
			if area.is_in_group('targets'):
				area.hover(self)
		
	if event.is_action_released('ui_touch'):
		# End dragging
		previous_mouse_position = Vector2()
		self.restore_area()
		set_dragging(false)
		
		# Check if dropped onto target
		for area in get_overlapping_areas():
			if area.is_in_group('targets'):
				var interacted = area.interact(self)
				if interacted:
					Events.emit_signal("card_destroyed", self)
					queue_free() # cards are single use
				
		emit_signal('dropped', self)
		Events.emit_signal("card_dropped", self)
		
func shrink_area():
	$CollisionShape2D.shape.extents.x = 1
	
func restore_area():
	$CollisionShape2D.shape.extents.x = 48
	
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
var playing_a_card = false

func set_hovering(v):
	hovering = v
	
	var target_scale
	if hovering:
		target_scale = 1.3*Vector2(1,1)
		$Label.visible = true
		$Description.visible = true
		z_index = 10
	else:
		target_scale = Vector2(1,1)
		$Label.visible = false
		$Description.visible = false
		z_index = 0
	
	scale_tween.interpolate_property(self, 'scale',
		scale, target_scale, 0.25,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	scale_tween.start()

func _on_Card_mouse_entered():
	if not playing_a_card:
		set_hovering(true)
	
func _on_Card_mouse_exited():
	set_hovering(false)

func _on_card_picked(card):
	playing_a_card = true
	
func _on_card_dropped(card):
	playing_a_card = false
	
func _on_card_destroyed(card):
	playing_a_card = false
	
func set_enabled(v):
	enabled = v
	$Outline.visible = enabled
