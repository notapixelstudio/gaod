extends Node2D

export var arrow_sprite : Texture
export var arrow_end_sprite : Texture
export var x := -14
export var y := -150
export var dx := 235
var steps = 0 setget set_steps

func _ready():
	Events.connect('mortal_about_to_move', self, '_on_mortal_about_to_move')
	
func set_steps(amount):
	if not self.is_inside_tree():
		yield(self, 'ready')
	
	steps = amount
	self.empty()
	
	for i in range(steps):
		var step = Sprite.new()
		
		if i == steps-1:
			step.texture = arrow_end_sprite
		else:
			step.texture = arrow_sprite
			
		step.centered = false
		step.position.y = y
		step.position.x = x+i*dx
		add_child(step)
	
func empty():
	for child in get_children():
		child.free()

func _on_mortal_about_to_move(value):
	self.set_steps(value)
	
