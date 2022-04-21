extends Node2D

var value = 6
signal rolled

func roll():
	$Sprite.visible = true
	$AnimationPlayer.play("Roll")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("rolled")
	
func _random_face():
	value = 1 + randi() % 6
	$Sprite.texture = load('res://assets/die/'+str(value)+'.png')
	
