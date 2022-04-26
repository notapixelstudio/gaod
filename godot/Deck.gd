extends Node

class_name Deck

var composition := [
	'empty',
	'springs',
	'angel dice'
]
var cards : Array

func _init():
	randomize()
	self.reset()
	
	Events.connect('new_cards_obtained', self, '_on_new_cards_obtained')
	
func reset():
	cards = [] + composition # duplicate
	cards.shuffle()

func draw():
	if len(cards) == 0:
		self.reset()
		
	return cards.pop_front() # no need to store used cards in a discard pile atm
	
func add_new_cards(new_cards):
	if len(new_cards) <= 0:
		return
		
	var a_new_card = new_cards.pop_front()
	composition.append_array(new_cards)
	self.reset() # do not wait for the deck to be emptied to start drawing the new cards
	cards.push_front(a_new_card) # one of the new cards is drawn as soon as possible
	
func _on_new_cards_obtained(new_cards):
	self.add_new_cards(new_cards)
