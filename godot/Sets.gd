extends Node

class_name Sets

var sets := {
	'carpenter' : [
		'empty',
		'empty',
		'ghost tile'
	],
	'clockwork': [
		'springs',
		'rewind',
		'forward',
		'bananas'
	],
	'wizard': [
		'lightbulbs',
		'lightbulbs',
		'empty'
	],
	'gambler': [
		'angel dice',
		'demon dice',
		'empty'
	]
}

func get_offer():
	var selected_sets = sets.keys()
	selected_sets.shuffle()
	selected_sets = selected_sets.slice(0,1)
	
	# two random cards from each set
	var result = {}
	
	for set in selected_sets:
		sets[set].shuffle()
		result[set] = ([] + sets[set]).slice(0,1)
	
	return result
