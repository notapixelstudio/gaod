extends Node2D

var turn = 0

func _ready():
	Events.connect('mortal_about_to_move', self, '_on_mortal_about_to_move')
	Events.connect('mortal_move_start', self, '_on_mortal_move_start')
	Events.connect('mortal_turn_end', self, '_on_mortal_turn_end')
	Events.connect('game_over', self, '_on_game_over')
	
	randomize()
	self.add_turn()
	
	yield(get_tree().create_timer(1), "timeout")
	$Hand.draw('X2')
	yield(get_tree().create_timer(0.5), "timeout")
	$Hand.draw('EMPTY')
	
	
	yield(get_tree().create_timer(1), "timeout")
	Events.emit_signal("mortal_turn_start")
	
func _on_Button_pressed():
	angel_turn_end()
	
func _on_mortal_about_to_move(steps):
	self.angel_turn_start()
	
func _on_mortal_move_start():
	$Path.move_mortal()
	yield($Path, 'mortal_moved')
	
	Events.emit_signal("mortal_turn_end")
	
func _on_mortal_turn_end():
	self.add_turn()
	Events.emit_signal("mortal_turn_start")
	
func angel_turn_start():
	$PassButton.disabled = false
	
func angel_turn_end():
	$PassButton.disabled = true
	Events.emit_signal("mortal_move_start")
	
func _on_game_over():
	print('GAME OVER')
	
func add_turn():
	turn += 1
	$TurnLabel.text = 'Turn ' + str(turn)
	
