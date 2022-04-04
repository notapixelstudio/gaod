extends Node2D

func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$Hand.draw('GROW')
	yield(get_tree().create_timer(0.5), "timeout")
	$Hand.draw('TALK')
	yield(get_tree().create_timer(0.5), "timeout")
	$Hand.draw('KILL')
