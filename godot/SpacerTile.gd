extends "res://Tile.gd"

func is_valid_target(card):
	return card.title in ['MAGNET']

func highlight():
	$Sprite.visible = true
	.highlight()
	
func remove_highlight():
	$Sprite.visible = false
	.remove_highlight()
