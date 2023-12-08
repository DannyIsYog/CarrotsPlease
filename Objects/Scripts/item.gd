extends CharacterBody2D

var draggingDistance
var dir
var dragging
var newPosition = Vector2()
@onready var originalPosition = self.transform
@onready var area2D = $Area2D

@export var movable : bool = false

var mouse_in = false
var reset = false

func _ready():
	pass
	
	
func _input(event):
	if not movable:
		return
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
	if not movable:
		return
	if dragging:
		velocity = (newPosition - position) * Vector2(30, 30)
		move_and_slide()
		reset = true
	if reset and not dragging:
		reset = false
		self.transform = originalPosition
		for area in area2D.get_overlapping_areas():
			print(area.get_parent().name)
	
 # Set these two functions through the Area2D Signals!!
func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false
