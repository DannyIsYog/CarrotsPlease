extends Node2D

class_name InvestigationRoom

@export var members_spawn_points : Array[Node2D]
@export var items_spawn_points : Array[Node2D]
@export var carrot_spawn_point : Node2D
@export var item_scene : PackedScene
@export var member_scene : PackedScene
@export var carrot_scene : PackedScene

@export var raindeer_json_file_path : String

@onready var items = $Items
@onready var members = $Members
@onready var carrot = $Carrot

var member_numbers = []
var members_instances : Array[Member]
var ready_members : int = 0

var timer = null
var is_raindeer = false

# Called when the node enters the scene tree for the first time.
func _ready():

	for i in range(members_spawn_points.size()):
		member_numbers.append(i + 1)
	member_numbers.shuffle()
	for spawn_point in items_spawn_points:
		spawn_item(spawn_point.position)
	for spawn_point in members_spawn_points:
		spawn_member(spawn_point)
	spawn_carrot(carrot_spawn_point)
	
func member_ready():
	ready_members += 1
	if ready_members == 10:
		set_raindeer()

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
	members_instances.append(temp_member)
	temp_member.position = spawn_point.position
	members.call_deferred("add_child", temp_member)

func spawn_carrot(spawn_point):
	var temp_carrot = carrot_scene.instantiate() as Carrot
	temp_carrot.position = spawn_point.position
	carrot.call_deferred("add_child", temp_carrot)

func set_raindeer():
	var raindeers = load_raindeer_json()
	var raindeer_name = raindeers.keys()[randi() % raindeers.size()]
	var random_deer_likes = raindeers[raindeer_name]
	members_instances[randi() % members_instances.size()].set_likes(raindeer_name, random_deer_likes)

func reveal_members(is_raindeer):
	for member in members_instances:
		member.reveal()
	
	self.is_raindeer = is_raindeer
	timer = Timer.new()
	add_child(timer)
	var callable = Callable(self, "end_game")
	timer.timeout.connect(callable)
	timer.set_wait_time(5.0)
	timer.start()

func end_game():
	get_parent().end_investigation(self, is_raindeer)

func load_raindeer_json() -> Dictionary:
	var file = FileAccess.open(raindeer_json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish["raindeers"]
