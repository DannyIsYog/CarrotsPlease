extends CharacterBody2D

class_name Item

var draggingDistance
var dir
var dragging
var newPosition = Vector2()
@onready var originalPosition = self.transform
@onready var area2D : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite
@onready var text : RichTextLabel = $Text
@onready var investigation_room = get_parent().get_parent()

@export var json_file_path : String
var category_name : String
var item_name : String

var mouse_in = false
var reset = false

func _ready():
	var item_list = load_json()
	category_name = item_list.keys()[randi() % item_list.size()]
	item_name = item_list[category_name][randi() % item_list[category_name].size()]
	
	var path_to_image = "res://Assets/Icons/" + category_name + "/" + item_name + ".png"

	var image = Image.new()

	image.load(path_to_image)
	
	sprite.texture = ImageTexture.create_from_image(image)
	
	text.text = item_name[0].to_upper() + item_name.substr(1,-1)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			draggingDistance = position.distance_to(get_viewport().get_mouse_position())
			dir = (get_viewport().get_mouse_position() - position).normalized()
			dragging = true
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir
		else:
			dragging = false
			
	elif event is InputEventMouseMotion:
		if dragging:
			newPosition = get_viewport().get_mouse_position() - draggingDistance * dir

func _physics_process(delta):
	if dragging:
		velocity = (newPosition - position) * Vector2(30, 30)
		move_and_slide()
		reset = true
	if reset and not dragging:
		reset = false
		self.transform = originalPosition
		var overlapping_areas = area2D.get_overlapping_areas()
		if(overlapping_areas.size() == 1):
			print(overlapping_areas[0].get_parent().get_like(category_name,item_name))
			investigation_room.spawn_item(position)
			queue_free()
 # Set these two functions through the Area2D Signals!!
func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false

func load_json() -> Dictionary:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish
