extends Node2D

var value = 6

func _ready():
	Events.connect("mortal_turn_start", self, '_on_mortal_turn_start')
	
func _on_mortal_turn_start():
	$Sprite.visible = true
	$AnimationPlayer.play("Roll")
	yield($AnimationPlayer, "animation_finished")
	Events.emit_signal("mortal_about_to_move", value)
	
func roll():
	value = 1 + randi() % 6
	$Sprite.texture = load('res://assets/die/'+str(value)+'.png')
	
