extends Node

@export var snowball_scene : PackedScene

var timer = null
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	var callable = Callable(self, "spawn_snowball")
	timer.timeout.connect(callable)
	timer.one_shot = false
	timer.set_wait_time(0.1)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_snowball():
	var position = Vector2(randi_range(100,1900),0)
	var temp_snowball = snowball_scene.instantiate() as Snowball
	temp_snowball.position = position
	self.call_deferred("add_child", temp_snowball)
