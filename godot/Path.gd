extends Node2D

const dropzones = 8
export var dropzone_scene : PackedScene
export var tile_scene : PackedScene

func setup_dropzones():
	for i in range(dropzones):
		var dz = dropzone_scene.instance()
		dz.position.x = -i*Tile.WIDTH
		$Dropzones.add_child(dz)
		
func setup_tiles():
	for i in range(dropzones):
		var tile = tile_scene.instance()
		tile.position.x = -i*Tile.WIDTH
		$Tiles.add_child(tile)

func _ready():
	Events.connect("preview_card_effect", self, '_on_preview_card_effect')
	
	self.setup_dropzones()
	self.setup_tiles()
	self.update_tile_positions()
	
func update_tile_positions():
	var offset := 0
	var tiles = $Tiles.get_children()
	for i in range(len(tiles)):
		tiles[i].gracefully_go_to( Vector2(-offset, 0) )
		offset += tiles[i].width

func _on_preview_card_effect():
	self.update_tile_positions()
