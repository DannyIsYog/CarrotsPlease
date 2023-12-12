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

@onready var timer_text = $Timer

var member_numbers = []
var members_instances : Array[Member]
var ready_members : int = 0

var timer = null
var is_raindeer = false

var time = 60000 # in ms
var time_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var number_of_members = load_members_json().size()
	member_numbers = generateUniqueIntegers(0, number_of_members-1, 10)
	member_numbers.shuffle()
	for spawn_point in items_spawn_points:
		spawn_item(spawn_point.position)
	for spawn_point in members_spawn_points:
		spawn_member(spawn_point)
	spawn_carrot(carrot_spawn_point)

func _process(delta):
	if time_running:
		time -= (int(delta*1000) + 1)
		if time < 0:
			time = 0
			time_running = false
			carrot.queue_free()
			reveal_members(false)
		timer_text.text = formatTime(time)

func formatTime(ms: int) -> String:
	var minutes = int(ms / 60000)
	var seconds = int((ms % 60000) / 1000)
	var milliseconds = int(ms % 1000)

	# Format the time components
	var formattedMinutes = str(minutes).pad_zeros(2)
	var formattedSeconds = str(seconds).pad_zeros(2)
	var formattedMilliseconds = str(milliseconds).pad_zeros(3)

	# Construct the time string
	var formattedTime = formattedMinutes + ":" + formattedSeconds + ":" + formattedMilliseconds

	return formattedTime

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
	time_running = false
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
	return finish["reindeers"]

func load_members_json() -> Dictionary:
	var file = FileAccess.open(raindeer_json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish["members"]

func generateUniqueIntegers(min_value: int, max_value: int, count: int) -> Array:
	var unique_integers = []
	
	# Ensure that the count does not exceed the possible number of unique integers in the range
	count = min(count, max_value - min_value + 1)
	
	while unique_integers.size() < count:
		var random_integer = randi() % (max_value - min_value + 1) + min_value
		
		# Check if the generated integer is unique
		if not random_integer in unique_integers:
			unique_integers.append(random_integer)
	
	return unique_integers

func new_sfx(sfx_path):
	var new_sound := AudioStreamPlayer.new()
	new_sound.autoplay = true
	new_sound.stream = load(sfx_path)
	new_sound.volume_db = -27
	add_child(new_sound)
	new_sound.finished.connect(new_sound.queue_free)
	
