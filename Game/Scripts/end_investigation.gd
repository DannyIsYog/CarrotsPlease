extends Node2D

@onready var text = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var game_manager : GameManager = get_parent()
	if game_manager.is_raindeer:
		text.text = "[center]You found the raindeer![/center]"
	else:
		text.text = "[center]The raindeer escaped![/center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
