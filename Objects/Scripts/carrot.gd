extends CharacterBody2D

class_name Carrot

var draggingDistance
var dir
var dragging
var newPosition = Vector2()
@onready var originalPosition = self.transform
@onready var area2D : Area2D = $Area2D
@onready var text : RichTextLabel = $Text
@onready var investigation_room = get_parent().get_parent()

var mouse_in = false
var reset = false

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
		text.text = ""
	if reset and not dragging:
		reset = false
		self.transform = originalPosition
		var overlapping_areas = area2D.get_overlapping_areas()
		if(overlapping_areas.size() == 1):
			print(overlapping_areas[0].get_parent().uncover())
			queue_free()
		set_text()

func set_text():
	text.text = "[center]ACCUSE![/center]"

func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false
