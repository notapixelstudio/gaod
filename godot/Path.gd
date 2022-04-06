extends Node2D

func _ready():
	Events.connect("preview_card_effect", self, '_on_preview_card_effect')
	
	self.update_tile_positions()

func update_tile_positions():
	var offset := -SpacerTile.SPACER_WIDTH/2
	var tiles = get_children()
	for i in range(len(tiles)):
		offset += tiles[i].width/2
		tiles[i].gracefully_go_to( Vector2(-offset, 0) )
		offset += tiles[i].width/2

func _on_preview_card_effect():
	self.update_tile_positions()
