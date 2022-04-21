extends Node

class_name Deck

var cards := [
	'springs',
	'angel dice'
]
var actual_cards : Array

var sets = [
	[
		'empty',
		'bananas',
		'demon dice'
	],
	[
		'empty',
		'empty',
		'springs',
		'angel dice'
	],
	[
		'demon dice',
		'demon dice',
		'bananas',
		'bananas'
	],
	[
		'lightbulbs',
		'empty',
		'empty',
		'empty',
		'empty',
		'bananas',
		'bananas',
		'angel dice',
		'angel dice',
		'springs',
		'springs',
		'demon dice',
		'demon dice'
	]
]

func _init():
	randomize()
	self.new_cards()
	
func new_cards():
	actual_cards = cards.slice(0, len(cards)-1)
	actual_cards.shuffle()
	
	# unlock more cards as you go
	if len(sets) > 0:
		cards.append_array(sets.pop_front())

func draw():
	if len(actual_cards) == 0:
		self.new_cards()
		
	return actual_cards.pop_front()
	
