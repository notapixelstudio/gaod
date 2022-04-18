extends Area2D

func _ready():
	$CollisionShape2D.shape.extents = Vector2(Tile.WIDTH/2, Tile.WIDTH/2)
