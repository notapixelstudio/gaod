extends Node2D

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$Hand.draw('MAGNET')
	yield(get_tree().create_timer(0.5), "timeout")
	$Hand.draw('GROW')
