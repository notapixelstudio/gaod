extends Node2D

const Card = preload('res://Card.tscn')

export var separation = 150
export var deck_global_position = Vector2(0,0)
export var enabled := true setget set_enabled

func draw(what):
	var card = Card.instance()
	card.enabled = enabled
	add_child(card)
	card.connect('dropped', self, '_on_Card_dropped')
	card.connect('tree_exited', self, '_on_Card_destroyed')
	card.title = what
	card.global_position = deck_global_position
	update_card_positions()
	
func update_card_positions():
	var cards = get_children()
	for i in range(len(cards)):
		cards[i].gracefully_go_to( Vector2( (i-len(cards)/2.0+0.5)*separation, 0) )
		
func _on_Card_dropped(card):
	update_card_positions()
	
func _on_Card_destroyed():
	update_card_positions()
	
func get_hand_size():
	return self.get_child_count()
		
func set_enabled(v):
	enabled = v
	for card in get_children():
		card.set_enabled(enabled)
		
