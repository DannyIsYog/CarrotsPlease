extends Node2D

@onready var text = $RichTextLabel
@onready var image = $RaindeerImage
@onready var raindeer_text = $RaindeerText

# Called when the node enters the scene tree for the first time.
func _ready():
	var game_manager : GameManager = get_parent()
	if game_manager.is_raindeer:
		text.text = "[center]You found the raindeer![/center]"
	else:
		text.text = "[center]The raindeer escaped![/center]"
	
	var path_to_image = "res://Assets/Raindeers/" + game_manager.raindeer_name  + ".png"
	
	image.texture = load(path_to_image)
		
	raindeer_text.text = "[center]" + game_manager.raindeer_name + "[/center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
