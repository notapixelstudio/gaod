extends Node2D

signal moved

func get_steps():
	return $Die.value

func move():
	$Tween.interpolate_property($Sprite, 'position:x',
		$Sprite.position.x, $Sprite.position.x+Tile.WIDTH, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	$AnimationPlayer.play("Jump")
	
func reset_move():
	$Sprite.position.x = 0
	
func _on_Tween_tween_all_completed():
	emit_signal('moved')
