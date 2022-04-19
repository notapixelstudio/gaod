extends Node2D

const dropzones = 8
export var dropzone_scene : PackedScene
export var tile_scene : PackedScene
export var mortal_scene : PackedScene
const starting_index = 5
var mortal
var mortal_index = starting_index
signal mortal_moved

var preview_index = null


func setup_dropzones():
	for i in range(dropzones):
		var dz = dropzone_scene.instance()
		dz.position.x = -i*Tile.WIDTH
		dz.connect('card_entered', self, '_on_card_entered_dropzone', [i])
		dz.connect('card_exited', self, '_on_card_exited_dropzone', [i])
		dz.connect('card_played', self, '_on_card_played_onto_dropzone', [i])
		$Dropzones.add_child(dz)
		
func setup_tiles():
	for i in range(dropzones):
		var tile = tile_scene.instance()
		tile.position.x = -i*Tile.WIDTH
		$Tiles.add_child(tile)
		tile.get_node('Label').text = str(i)
		
		if i == starting_index:
			mortal = mortal_scene.instance()
			tile.add_child(mortal)
			

func _ready():
	Events.connect("preview_card_effect", self, '_on_preview_card_effect')
	
	self.setup_dropzones()
	self.setup_tiles()
	self.update_tile_positions()
	
func update_tile_positions(instantly = false):
	var offset := 0
	var tiles = $Tiles.get_children()
	for i in range(len(tiles)):
		if preview_index == i:
			offset += Tile.WIDTH
		
		if instantly:
			tiles[i].position = Vector2(-offset, 0)
		else:
			tiles[i].gracefully_go_to( Vector2(-offset, 0) )
			
		offset += Tile.WIDTH

func _on_preview_card_effect():
	self.update_tile_positions()

func _on_card_entered_dropzone(i):
	preview_index = i
	self.update_tile_positions()
	
func _on_card_exited_dropzone(i):
	preview_index = null
	# wait a bit to see if the players selects a new dropzone right away
	yield(get_tree().create_timer(0.2), "timeout")
	if preview_index == null:
		self.update_tile_positions()

func _on_card_played_onto_dropzone(card, i):
	preview_index = null
	var tile = tile_scene.instance()
	tile.set_title(card.title)
	$Tiles.add_child(tile)
	$Tiles.move_child(tile, i)
	self.update_tile_positions(true) # instantly
	
	self.remove_excess_tiles()
	
func remove_excess_tiles():
	for i in range(dropzones, len($Tiles.get_children())):
		var tile = $Tiles.get_child(i)
		tile.queue_free()

func move_mortal():
	var steps = mortal.get_steps()
	var new_index = mortal_index - steps # 0 is at the right end of the path
	if new_index < 0:
		# GAME OVER
		return
		
	for i in range(steps):
		mortal.move()
		yield(mortal, 'moved')
		mortal_index -= 1
		
	mortal.reset_move()
	mortal.get_parent().remove_child(mortal)
	$Tiles.get_child(mortal_index).add_child(mortal)
	
	emit_signal('mortal_moved')
	
