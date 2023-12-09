extends Node2D

class_name Member

@onready var area2D : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite
@onready var text : RichTextLabel = $Text
@onready var emotionSprite : Sprite2D = $Emotion
@onready var investigation_room = get_parent().get_parent()

@export var json_file_path : String

var username : String
var likes

var timer = null

func _ready():
	print("ready item")
	var member_list = load_json()
	username = member_list.keys()[investigation_room.get_member_number()]
	likes = member_list[username]
	
	var path_to_image = "res://Assets/Members/" + username + ".png"

	var image = Image.new()

	image.load(path_to_image)
	
	sprite.texture = ImageTexture.create_from_image(image)
	
	text.text = "[center]" + username.split(" ")[0] + "[/center]\n" + "[center]" + username.split(" ")[1] + "[/center]"
	print(username)
	print(likes)
	
func get_like(category, item_name):
	var path_to_image = "res://Assets/Emotions/" + likes[category][item_name] + ".png"

	var image = Image.new()

	image.load(path_to_image)
	
	emotionSprite.texture = ImageTexture.create_from_image(image)
	
	timer = Timer.new()
	add_child(timer)
	var callable = Callable(self, "remove_emotion")
	timer.timeout.connect(callable)
	timer.set_wait_time(1.0)
	timer.start()
	
	return likes[category][item_name]

func remove_emotion():
	emotionSprite.texture = null

func load_json() -> Dictionary:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish["members"]
