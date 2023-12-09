extends Node2D

class_name Member

@onready var area2D : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite
@onready var text : RichTextLabel = $Text
@onready var emotionSprite : Sprite2D = $Emotion
@onready var investigation_room : InvestigationRoom = get_parent().get_parent()

@export var json_file_path : String

var username : String
var likes

var is_raindeer : bool = false
var raindeer_name : String

var timer = null

func _ready():
	print("ready item")
	var member_list = load_json()
	username = member_list.keys()[investigation_room.get_member_number()]
	likes = member_list[username]
	
	set_member(username, likes)
	
	investigation_room.member_ready()
	
func get_like(category, item_name):
	var path_to_image = "res://Assets/Emotions/" + likes[category][item_name] + ".png"

	var image = Image.new()

	image.load(path_to_image)
	
	emotionSprite.texture = ImageTexture.create_from_image(image)
	
	if timer != null:
		timer.stop()
	timer = Timer.new()
	add_child(timer)
	var callable = Callable(self, "remove_emotion")
	timer.timeout.connect(callable)
	timer.set_wait_time(1.5)
	timer.start()
	
	return likes[category][item_name]

func remove_emotion():
	emotionSprite.texture = null

func set_member(username, likes):
	var path_to_image = "res://Assets/Members/" + username + ".png"
	
	sprite.texture = load(path_to_image)
	
	text.text = "[center]" + username.split(" ")[0] + "[/center]\n" + "[center]" + username.split(" ")[1] + "[/center]"
	print(username)
	print(likes)

func set_likes(raindeer_name, likes):
	self.likes = likes
	is_raindeer = true
	self.raindeer_name = raindeer_name
	print("Setting Raindeer")
	print(username)
	print(raindeer_name)

func uncover():
	investigation_room.reveal_members(is_raindeer)
	

func reveal():
	if is_raindeer:
		var path_to_image = "res://Assets/Raindeers/Raindeer.png"
		var image = Image.new()

		image.load(path_to_image)
	
		sprite.texture = ImageTexture.create_from_image(image)

func load_json() -> Dictionary:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish["members"]
