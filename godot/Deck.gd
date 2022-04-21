extends Node

class_name Deck

var cards := [
	'springs',
	'angel dice'
]
var actual_cards : Array

func _init():
	randomize()
	self.new_cards()
	
func new_cards():
	actual_cards = cards.slice(0, len(cards)-1)
	actual_cards.shuffle()

func draw():
	if len(actual_cards) == 0:
		self.new_cards()
		
	return actual_cards.pop_front()
	
