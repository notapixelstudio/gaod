extends Node2D

const dropzones = 8
export var dropzone_scene : PackedScene
export var tile_scene : PackedScene
export var mortal_scene : PackedScene
const starting_index = 5
var mortal
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
	
	Events.emit_signal("card_played", card)
	
func remove_excess_tiles():
	for i in range(dropzones, len($Tiles.get_children())):
		var tile = $Tiles.get_child(i)
		tile.queue_free()

func move_mortal():
	var steps = mortal.get_steps()
	var mortal_index = self.find_mortal_index()
	
	mortal.premove()
	yield(mortal, 'premoved')
	
	for i in range(abs(steps)):
		mortal.move()
		yield(mortal, 'moved')
		mortal_index += mortal.get_direction()
		
		# die if the right side of the screen is reached
		if mortal_index < 0:
			Events.emit_signal("game_over")
			return
		
		# stop movement if the left side of the screen is reached
		if mortal_index >= dropzones-1 and mortal.is_direction_backwards():
			break
		
	mortal.postmove()
	mortal.get_parent().remove_child(mortal)
	var current_tile = $Tiles.get_child(mortal_index)
	current_tile.add_child(mortal)
	mortal.reset_move()
	self.remove_excess_tiles()
	
	current_tile.activate(mortal)
	
func find_mortal_index():
	for i in range($Tiles.get_child_count()):
		if $Tiles.get_child(i).has_node('Mortal'): # WARNING name is used as check
			return i
	return null
