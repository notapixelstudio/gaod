extends Tile
class_name SpacerTile

const SPACER_WIDTH := 16

func _init():
	width = SPACER_WIDTH

func is_valid_target(card):
	return card.title in ['MAGNET']

func highlight():
	$Sprite.visible = true
	.highlight()
	
func remove_highlight():
	$Sprite.visible = false
	.remove_highlight()

func focus():
	self.width = SPACER_WIDTH*2 + Tile.WIDTH
	$CollisionShape2D.shape.extents.x = self.width
	.focus()
	Events.emit_signal('preview_card_effect')

func blur():
	self.width = SPACER_WIDTH
	$CollisionShape2D.shape.extents.x = self.width
	.blur()
	Events.emit_signal('preview_card_effect')
	
