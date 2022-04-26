extends Node2D

var offers := []

func open(v : Dictionary):
	offers = v.values()
	for i in range(len(offers)):
		$Offers.get_child(i).get_node('Card').set_title(offers[i][0])
		$Offers.get_child(i).get_node('Card2').set_title(offers[i][1])
	visible = true
	
func close():
	visible = false
	Events.emit_signal("leveled_up")
	
func _on_loot_chosen(index):
	Events.emit_signal("new_cards_obtained", offers[index])
	close()
	
