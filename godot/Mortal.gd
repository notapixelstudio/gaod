extends Node2D

signal premoved
signal moved

const COLORS = [
	Color(1,1,1,1),
	Color(1,0.8,0.5,1),
	Color(1,0.5,0.8,1),
	Color(0.5,1,0.8,1),
	Color(0.8,1,0.5,1),
	Color(0.5,0.8,1,1),
	Color(0.8,0.5,1,1)
]

func _ready():
	randomize()
	$Sprite.modulate = COLORS[randi() % len(COLORS)]

func get_steps():
	return $Die.value

func premove():
	$AnimationPlayer.play("Prejump")
	yield($AnimationPlayer, "animation_finished")
	emit_signal('premoved')
	
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

func postmove():
	$AnimationPlayer.play_backwards("Prejump")
