extends Node2D

class_name Snowball

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += 30
	if position.y > 2000:
		queue_free()
