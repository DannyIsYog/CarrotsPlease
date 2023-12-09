extends CharacterBody2D

var mouse_in = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			get_tree().quit()

func mouse_entered():
	mouse_in = true

func mouse_exited():
	mouse_in = false
