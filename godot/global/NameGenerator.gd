extends Node

var first_names := [
	'Tim',
	'Sonya',
	'Jing',
	'Charles',
	'Franca',
	'Jean',
	'Salvo',
	'Vetulia',
	'Len',
	'Zed',
	'Mark',
	'Jonas',
	'India',
	'Carlos',
	'Hannah',
	'Carolus'
]
var last_names := [
	'Meepolus',
	'Ogronian',
	'Cafis',
	'Buhud',
	'Xinnu',
	"T'Grohl",
	'De Kinfix',
	'Mc Phooba',
	'Gololod',
	'Akky',
	'Antanas',
	'Carbonnen',
	'Yergil'
]

func _ready():
	randomize()
	
func get_name():
	first_names.shuffle()
	last_names.shuffle()
	return first_names[0] + ' ' + last_names[0]
