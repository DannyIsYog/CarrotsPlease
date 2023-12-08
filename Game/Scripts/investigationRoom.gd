extends Node2D

@export var members_spawn_points : Array[Node2D]
@export var items_spawn_points : Array[Node2D]
@export var item_scene : PackedScene
@export var member_scene : PackedScene

@export var json_file_path : String

@onready var items = $Items
@onready var members = $Members

var member_numbers = []

# Called when the node enters the scene tree for the first time.
func _ready():

	for i in range(members_spawn_points.size()):
		member_numbers.append(i + 1)
	member_numbers.shuffle()
	for spawn_point in items_spawn_points:
		spawn_item(spawn_point.position)
	for spawn_point in members_spawn_points:
		spawn_member(spawn_point)

func get_member_number():
	var number = member_numbers[0]
	member_numbers.remove_at(0)
	return number

func spawn_item(spawn_point):
	var temp_item = item_scene.instantiate() as Item
	temp_item.position = spawn_point
	items.call_deferred("add_child", temp_item)

func spawn_member(spawn_point):
	var temp_member = member_scene.instantiate() as Member
	temp_member.position = spawn_point.position
	members.call_deferred("add_child", temp_member)

func read_json():
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish
