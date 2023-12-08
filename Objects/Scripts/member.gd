extends Node2D

class_name Member

@onready var area2D : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite
@onready var text : RichTextLabel = $Text
@onready var investigation_room = get_parent().get_parent()

@export var json_file_path : String

var username : String
var likes

func _ready():
	print("ready item")
	var member_list = load_json()
	username = member_list.keys()[investigation_room.get_member_number()]
	likes = member_list[username]
	
	#var path_to_image = "res://Assets/Members/" + username + ".png"
	var path_to_image = "res://icon.svg"

	var image = Image.new()

	image.load(path_to_image)
	
	sprite.texture = ImageTexture.create_from_image(image)
	
	text.text = username
	print(username)
	print(likes)
	
func get_like(category, item_name):
	return likes[category][item_name]

func load_json() -> Dictionary:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish["members"]
