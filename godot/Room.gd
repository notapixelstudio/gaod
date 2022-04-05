extends Node2D

func _ready():
	Events.connect('mortal_about_to_move', self, '_on_mortal_about_to_move')
	Events.connect('mortal_move_start', self, '_on_mortal_move_start')
	
	randomize()
	
	yield(get_tree().create_timer(1), "timeout")
	$Hand.draw('MAGNET')
	yield(get_tree().create_timer(0.5), "timeout")
	$Hand.draw('GROW')
	
	
	yield(get_tree().create_timer(1), "timeout")
	Events.emit_signal("mortal_turn_start")
	
func _on_Button_pressed():
	angel_turn_end()
	
func _on_mortal_about_to_move(steps):
	self.angel_turn_start()
	
func _on_mortal_move_start():
	var mortal = $Path.find_node("Mortal")
	var steps = mortal.get_steps()
	
	#var starting_tile = mortal.get_parent()
	#var start_tile_index = $Path.get_tile_index(starting_tile)
	#$Path.get_tile(steps+start_tile_index)
	
	#var num_tile = starting_tile.name.replace("Tile", "")
	#var next_tile = "Tile"+str(int(num_tile) + steps)
	#get_node(next_tile).add_child(mortal)
	
	# Events.emit_signal("mortal_turn_end")
	Events.emit_signal("mortal_turn_start")
	
func angel_turn_start():
	$PassButton.disabled = false
	
func angel_turn_end():
	$PassButton.disabled = true
	Events.emit_signal("mortal_move_start")
