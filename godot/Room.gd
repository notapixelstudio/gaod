extends Node2D

var turn = 0
var deck

func _ready():
	Events.connect('mortal_about_to_move', self, '_on_mortal_about_to_move')
	Events.connect('mortal_move_start', self, '_on_mortal_move_start')
	Events.connect('mortal_turn_end', self, '_on_mortal_turn_end')
	Events.connect('card_played', self, '_on_card_played')
	Events.connect('game_over', self, '_on_game_over')
	
	randomize()
	
	deck = Deck.new()
	
	self.greet_mortal()
	yield(get_tree().create_timer(3), "timeout")
	self.add_turn()
	Events.emit_signal("mortal_turn_start")
	
func _on_Button_pressed():
	angel_turn_end()

func _on_card_played(card):
	angel_turn_end()
	
func _on_mortal_about_to_move(steps):
	self.angel_turn_start()
	
func _on_mortal_move_start():
	$Path.move_mortal()
	
func _on_mortal_turn_end():
	self.add_turn()
	Events.emit_signal("mortal_turn_start")
	
func angel_turn_start():
	yield(get_tree().create_timer(0.5), "timeout")
	
	if turn == 1:
		self.draw(2)
	else:
		self.draw()
		
	$PassButton.disabled = false
	
func angel_turn_end():
	$PassButton.disabled = true
	Events.emit_signal("mortal_move_start")
	
func _on_game_over():
	print('GAME OVER')
	
func add_turn():
	turn += 1
	$TurnLabel.text = 'Turn ' + str(turn)
	
func draw(how_many = 1):
	for i in range(how_many):
		$Hand.draw(deck.draw())
		yield(get_tree().create_timer(0.5), "timeout")
		
func greet_mortal():
	var name = NameGenerator.get_name()
	$TurnLabel.text = 'This is the life of ' + name
