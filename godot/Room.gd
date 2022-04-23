extends Node2D

var start := true
var turn := 0
var deck
var max_hand_size := 2

func _ready():
	Events.connect('mortal_about_to_move', self, '_on_mortal_about_to_move')
	Events.connect('mortal_move_start', self, '_on_mortal_move_start')
	Events.connect('mortal_turn_end', self, '_on_mortal_turn_end')
	Events.connect('card_played', self, '_on_card_played')
	Events.connect('game_over', self, '_on_game_over')
	Events.connect('draw_effect_activated', self, '_on_draw_effect_activated')
	Events.connect('tile_activated', self, '_on_tile_activated')
	
	randomize()
	
	deck = Deck.new()
	
	yield(get_tree().create_timer(1), "timeout")
	self.greet_mortal()
	yield(get_tree().create_timer(2), "timeout")
	$TurnLabel.text = 'Turn 1'
	$AnimationPlayer.play("Intro")
	yield($AnimationPlayer, "animation_finished")
	Events.emit_signal("mortal_turn_start")
	
func _on_Button_pressed():
	angel_turn_end()

func _on_card_played(card):
	$AudioStreamPlayer.stream = load('res://assets/sounds/placement.ogg')
	$AudioStreamPlayer.play()
	#angel_turn_end()
	
func _on_mortal_about_to_move(steps):
	self.angel_turn_start()
	
func _on_mortal_move_start():
	$Path.move_mortal()
	
func _on_mortal_turn_end():
	Events.emit_signal("mortal_turn_start")
	
func angel_turn_start():
	yield(get_tree().create_timer(0.5), "timeout")
	self.add_turn()
	yield(get_tree().create_timer(0.5), "timeout")
	
	if start:
		self.draw(2)
		start = false
	else:
		if $Hand.get_hand_size() < max_hand_size:
			self.draw()
			
	yield(get_tree().create_timer(0.5), "timeout")
	$PassButton.enable()
	$Hand.enabled = true
	
func angel_turn_end():
	$PassButton.disable()
	$Hand.enabled = false
	Events.emit_signal("mortal_move_start")
	
func _on_game_over():
	$GameOverSFX.play()
	yield($GameOverSFX, "finished")
	yield(get_tree().create_timer(0.2), "timeout")
	$GameOver.visible = true
	
func add_turn():
	turn += 1
	$TurnLabel.text = 'Turn ' + str(turn)
	
func draw(how_many = 1):
	for i in range(how_many):
		$Hand.draw(deck.draw())
		$AudioStreamPlayer2.play()
		yield(get_tree().create_timer(0.5), "timeout")
		
func greet_mortal():
	var name = NameGenerator.get_name()
	$TurnLabel.text = 'This is the life of ' + name

func _on_draw_effect_activated():
	# draw two regardless of hand size
	self.draw(2)

func _on_tile_activated(tile):
	$AudioStreamPlayer.stream = load('res://assets/sounds/'+tile.title.to_lower()+'.ogg')
	$AudioStreamPlayer.play()


func _on_TryAgain_pressed():
	get_tree().reload_current_scene()
