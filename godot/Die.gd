extends Node2D

var value = 6
signal rolled

func _ready():
	Events.connect('mortal_move_start', self, '_on_mortal_move_start')

func roll():
	$Sprite.visible = true
	$AnimationPlayer.play("Roll")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("rolled")
	
func _random_face():
	value = 1 + randi() % 6
	$Sprite.texture = load('res://assets/die/'+str(value)+'.png')
	
func _on_mortal_move_start():
	$Sprite.visible = false
	
func force_value(v):
	value = v
	
