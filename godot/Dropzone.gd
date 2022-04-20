extends Area2D

signal card_entered
signal card_exited
signal card_played

func _ready():
	$CollisionShape2D.shape.extents = Vector2(Tile.WIDTH/2, Tile.WIDTH/2)
	$ColorRect.rect_position = Vector2(-Tile.WIDTH/2, -Tile.WIDTH/2)
	$ColorRect.rect_size = Vector2(Tile.WIDTH, Tile.WIDTH)
	
	Events.connect('card_picked', self, '_on_card_picked')
	Events.connect('card_dropped', self, '_on_card_dropped')
	Events.connect('card_destroyed', self, '_on_card_destroyed')

# BUSINESS LOGIC
func interact(card):
	if not self.is_valid_target(card):
		return
		
	if card.title:
		emit_signal('card_played', card)
		return true
	
	return false
	
func is_valid_target(card):
	return card.title in ['springs', 'bananas']

# HOVER
func hover(card):
	if not self.is_valid_target(card):
		return
	
	focus()
	emit_signal('card_entered')
	
func _on_Dropzone_area_exited(area):
	if not(area is Card):
		return
		
	blur()
	emit_signal('card_exited')
	
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
	$ColorRect.visible = true
	
func remove_highlight():
	$ColorRect.visible = false
	
func focus():
	$ColorRect.color = Color('#ffcc00')

func blur():
	$ColorRect.color = Color('#ff6c00')
