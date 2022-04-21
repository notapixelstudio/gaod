extends Node2D

var direction := -1

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
	
	Events.connect("mortal_turn_start", self, '_on_mortal_turn_start')
	
func _on_mortal_turn_start():
	$Die.roll()
	yield($Die, "rolled")
	Events.emit_signal("mortal_about_to_move", self.get_steps())

func get_steps():
	return $Die.value * direction

func premove():
	$AnimationPlayer.play("Prejump")
	yield($AnimationPlayer, "animation_finished")
	emit_signal('premoved')
	
func move():
	$Tween.interpolate_property($Sprite, 'position:x',
		$Sprite.position.x, $Sprite.position.x-Tile.WIDTH*direction, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	$AnimationPlayer.play("Jump")
	
func reset_move():
	$Sprite.position.x = 0
	
func _on_Tween_tween_all_completed():
	emit_signal('moved')

func postmove():
	$AnimationPlayer.play_backwards("Prejump")
	Events.emit_signal("mortal_moved")

func get_direction():
	return direction
	
func flip_direction():
	self._set_direction(-direction)
	
func set_direction_forward():
	self._set_direction(-1)
	
func set_direction_backwards():
	self._set_direction(+1)
	
func is_direction_backwards():
	return direction == +1
	
func is_direction_forward():
	return direction == -1
	
func _set_direction(v):
	direction = v
