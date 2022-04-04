extends Node2D

export var separation = 44

func _ready():
	self.update_tile_positions()

func update_tile_positions():
	var tiles = get_children()
	for i in range(len(tiles)):
		tiles[i].gracefully_go_to( Vector2( (-i)*separation, 0) )
